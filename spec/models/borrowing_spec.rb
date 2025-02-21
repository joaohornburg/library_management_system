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
  end
end
