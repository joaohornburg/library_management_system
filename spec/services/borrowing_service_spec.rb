# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BorrowingService do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', role: :member) }
  let(:book) { Book.create!(title: 'Test Book', author: 'Test Author', isbn: '1234567890', total_copies: 1) }
  let(:service) { described_class.new(user) }

  describe '#create_borrowing' do
    it 'creates a new borrowing with correct attributes' do
      borrowing = service.create_borrowing(book.id)

      expect(borrowing.user).to eq(user)
      expect(borrowing.book_id).to eq(book.id)
      expect(borrowing.borrowed_at).to be_present
      expect(borrowing.due_date).to be_present
      expect(borrowing.due_date).to be_within(1.second).of(2.weeks.from_now)
    end
  end

  describe '#return_borrowing' do
    it 'marks the borrowing as returned' do
      borrowing = Borrowing.create!(
        user:,
        book:,
        borrowed_at: Time.current,
        due_date: 2.weeks.from_now
      )

      returned_borrowing = service.return_borrowing(borrowing)
      expect(returned_borrowing.returned_at).to be_present
    end
  end
end
