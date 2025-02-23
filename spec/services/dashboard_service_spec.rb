# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardService do
  let(:librarian) { User.create!(email: 'librarian@example.com', password: 'password', role: :librarian) }
  let(:member) { User.create!(email: 'member@example.com', password: 'password', role: :member) }
  let(:book1) { Book.create!(title: 'Book 1', author: 'Author 1', isbn: '1234567890', total_copies: 1) }
  let(:book2) { Book.create!(title: 'Book 2', author: 'Author 2', isbn: '0987654321', total_copies: 1) }

  before do
    allow_any_instance_of(Borrowing).to receive(:book_must_be_available).and_return(true)
  end

  describe '#stats' do
    context 'when user is a librarian' do
      let(:service) { described_class.new(librarian) }

      before do
        Borrowing.create!(
          user: member,
          book: book1,
          borrowed_at: Time.current,
          due_date: Time.current.end_of_day
        )

        Borrowing.create!(
          user: member,
          book: book2,
          borrowed_at: 3.weeks.ago,
          due_date: 1.week.ago
        )
      end

      it 'returns librarian dashboard statistics' do
        stats = service.stats

        expect(stats[:total_books]).to eq(2)
        expect(stats[:total_borrowed_books]).to eq(2)

        expect(stats[:books_due_today]).to contain_exactly(
          hash_including(
            book_title: 'Book 1',
            user_email: member.email,
            due_date: be_within(1.day).of(Time.current)
          )
        )

        expect(stats[:overdue_borrowings]).to contain_exactly(
          hash_including(
            book_title: 'Book 2',
            user_email: member.email,
            due_date: be_within(1.day).of(1.week.ago),
            days_overdue: be_within(1).of(7)
          )
        )
      end
    end

    context 'when user is a member' do
      let(:service) { described_class.new(member) }

      before do
        Borrowing.create!(
          user: member,
          book: book1,
          borrowed_at: Time.current,
          due_date: 2.weeks.from_now
        )

        Borrowing.create!(
          user: member,
          book: book2,
          borrowed_at: 3.weeks.ago,
          due_date: 1.week.ago
        )

        other_member = User.create!(email: 'other@example.com', password: 'password', role: :member)
        Borrowing.create!(
          user: other_member,
          book: book1,
          borrowed_at: Time.current,
          due_date: 2.weeks.from_now
        )
      end

      it 'returns member dashboard statistics' do
        stats = service.stats

        expect(stats[:current_borrowings]).to contain_exactly(
          hash_including(
            book_title: 'Book 1',
            due_date: be_within(1.day).of(2.weeks.from_now),
            overdue: false
          ),
          hash_including(
            book_title: 'Book 2',
            due_date: be_within(1.day).of(1.week.ago),
            overdue: true
          )
        )

        expect(stats[:overdue_borrowings]).to contain_exactly(
          hash_including(
            book_title: 'Book 2',
            due_date: be_within(1.day).of(1.week.ago),
            days_overdue: be_within(1).of(7)
          )
        )
      end
    end
  end
end
