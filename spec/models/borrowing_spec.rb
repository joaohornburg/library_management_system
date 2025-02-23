# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', role: :member) }
  let(:book) { Book.create!(title: 'Test Book', author: 'Test Author', isbn: '1234567890', total_copies: 1) }

  subject do
    described_class.new(
      user:,
      book:,
      borrowed_at: Time.current,
      due_date: 2.weeks.from_now
    )
  end

  describe 'associations' do
    before do
      allow_any_instance_of(Borrowing).to receive(:book_must_be_available)
    end

    it { should belong_to(:user) }
    it { should belong_to(:book) }
  end

  it { should validate_presence_of(:borrowed_at) }
  it { should validate_presence_of(:due_date) }

  describe 'book availability validation' do
    context 'when book has available copies' do
      it 'allows borrowing' do
        borrowing = Borrowing.new(
          user:,
          book:,
          borrowed_at: Time.current,
          due_date: 2.weeks.from_now
        )
        expect(borrowing).to be_valid
      end
    end

    context 'when all copies are borrowed' do
      before do
        Borrowing.create!(
          user:,
          book:,
          borrowed_at: Time.current,
          due_date: 2.weeks.from_now
        )
      end

      it 'prevents borrowing' do
        another_user = User.create!(email: 'another@example.com', password: 'password', role: :member)
        borrowing = Borrowing.new(
          user: another_user,
          book:,
          borrowed_at: Time.current,
          due_date: 2.weeks.from_now
        )
        expect(borrowing).not_to be_valid
        expect(borrowing.errors[:base]).to include('Book is not available for borrowing')
      end
    end
  end

  describe 'scopes' do
    let(:user) { User.create!(email: 'test@example.com', password: 'password', role: :member) }

    before do
      allow_any_instance_of(Borrowing).to receive(:book_must_be_available).and_return(true)
    end

    describe '.active' do
      let!(:active_borrowing) do
        Borrowing.create!(
          user:,
          book:,
          borrowed_at: Time.current,
          due_date: 2.weeks.from_now
        )
      end

      let!(:returned_borrowing) do
        borrowing = Borrowing.new(
          user:,
          book:,
          borrowed_at: 1.month.ago,
          due_date: 2.weeks.ago,
          returned_at: 1.week.ago
        )
        borrowing.save(validate: false)
        borrowing
      end

      it 'returns only active borrowings' do
        expect(Borrowing.active).to eq([active_borrowing])
      end

      it 'does not return returned borrowings' do
        expect(Borrowing.active).not_to include(returned_borrowing)
      end
    end

    describe '.overdue' do
      let(:overdue_book) do
        Book.create!(title: 'Overdue Book', author: 'Test Author', isbn: '1111111111', total_copies: 1)
      end
      let(:current_book) do
        Book.create!(title: 'Current Book', author: 'Test Author', isbn: '2222222222', total_copies: 1)
      end
      let(:returned_book) do
        Book.create!(title: 'Returned Book', author: 'Test Author', isbn: '3333333333', total_copies: 1)
      end

      let!(:overdue_borrowing) do
        Borrowing.create!(
          user:,
          book: overdue_book,
          borrowed_at: 3.weeks.ago,
          due_date: 1.week.ago
        )
      end

      let!(:current_borrowing) do
        Borrowing.create!(
          user:,
          book: current_book,
          borrowed_at: Time.current,
          due_date: 1.week.from_now
        )
      end

      let!(:returned_overdue_borrowing) do
        borrowing = Borrowing.new(
          user:,
          book: returned_book,
          borrowed_at: 3.weeks.ago,
          due_date: 1.week.ago,
          returned_at: Time.current
        )
        borrowing.save(validate: false)
        borrowing
      end

      it 'returns only active overdue borrowings' do
        expect(Borrowing.overdue).to eq([overdue_borrowing])
      end

      it 'does not return current borrowings' do
        expect(Borrowing.overdue).not_to include(current_borrowing)
      end

      it 'does not return returned borrowings' do
        expect(Borrowing.overdue).not_to include(returned_overdue_borrowing)
      end
    end

    describe '.due_today' do
      let(:due_today_book) do
        Book.create!(title: 'Due Today Book', author: 'Test Author', isbn: '4444444444', total_copies: 1)
      end
      let(:due_tomorrow_book) do
        Book.create!(title: 'Due Tomorrow Book', author: 'Test Author', isbn: '5555555555', total_copies: 1)
      end
      let(:returned_book) do
        Book.create!(title: 'Returned Today Book', author: 'Test Author', isbn: '6666666666', total_copies: 1)
      end

      let!(:due_today_borrowing) do
        Borrowing.create!(
          user:,
          book: due_today_book,
          borrowed_at: 2.weeks.ago,
          due_date: Time.current.end_of_day
        )
      end

      let!(:due_tomorrow_borrowing) do
        Borrowing.create!(
          user:,
          book: due_tomorrow_book,
          borrowed_at: 2.weeks.ago,
          due_date: 1.day.from_now
        )
      end

      let!(:returned_due_today_borrowing) do
        borrowing = Borrowing.new(
          user:,
          book: returned_book,
          borrowed_at: 2.weeks.ago,
          due_date: Time.current.end_of_day,
          returned_at: 1.hour.ago
        )
        borrowing.save(validate: false)
        borrowing
      end

      it 'returns only active borrowings due today' do
        expect(Borrowing.due_today).to eq([due_today_borrowing])
      end

      it 'does not return borrowings due on other days' do
        expect(Borrowing.due_today).not_to include(due_tomorrow_borrowing)
      end

      it 'does not return returned borrowings' do
        expect(Borrowing.due_today).not_to include(returned_due_today_borrowing)
      end
    end
  end

  describe '#overdue?' do
    context 'when due date is in the past' do
      subject do
        Borrowing.new(
          user:,
          book:,
          borrowed_at: 2.weeks.ago,
          due_date: 1.week.ago
        )
      end

      it 'returns true' do
        expect(subject.overdue?).to be true
      end

      context 'when book is returned' do
        before { subject.returned_at = Time.current }

        it 'returns false' do
          expect(subject.overdue?).to be false
        end
      end
    end

    context 'when due date is in the future' do
      subject do
        Borrowing.new(
          user:,
          book:,
          borrowed_at: Time.current,
          due_date: 1.week.from_now
        )
      end

      it 'returns false' do
        expect(subject.overdue?).to be false
      end
    end

    context 'when due date is today' do
      subject do
        Borrowing.new(
          user:,
          book:,
          borrowed_at: Time.current,
          due_date: Time.current
        )
      end

      it 'returns false' do
        expect(subject.overdue?).to be false
      end
    end
  end
end
