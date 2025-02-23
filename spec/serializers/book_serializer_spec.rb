require 'rails_helper'

RSpec.describe BookSerializer do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', role: :member) }
  let(:book) { Book.create!(title: 'Test Book', author: 'Test Author', isbn: '1234567890', total_copies: 2) }

  describe '.render' do
    context 'when book has no borrowings' do
      it 'returns correct serialized data' do
        serialized_book = BookSerializer.render(book, user)

        expect(serialized_book).to include(
          id: book.id,
          title: book.title,
          author: book.author,
          genre: book.genre,
          isbn: book.isbn,
          total_copies: 2,
          available_copies: 2,
          available: true,
          current_user_borrowing: nil
        )
      end
    end

    context 'when current user has borrowed the book' do
      let!(:borrowing) do
        Borrowing.create!(
          user: user,
          book: book,
          borrowed_at: Time.current,
          due_date: 2.weeks.from_now
        )
      end

      it 'returns correct serialized data with current user borrowing info' do
        serialized_book = BookSerializer.render(book, user)

        expect(serialized_book).to include(
          id: book.id,
          title: book.title,
          author: book.author,
          genre: book.genre,
          isbn: book.isbn,
          total_copies: 2,
          available_copies: 1,
          available: true,
          current_user_borrowing: {
            due_date: be_within(1.second).of(2.weeks.from_now)
          }
        )
      end
    end

    context 'when another user has borrowed the book' do
      let(:other_user) { User.create!(email: 'other@example.com', password: 'password', role: :member) }
      
      before do
        Borrowing.create!(
          user: other_user,
          book: book,
          borrowed_at: Time.current,
          due_date: 2.weeks.from_now
        )
      end

      it 'returns correct serialized data without current user borrowing info' do
        serialized_book = BookSerializer.render(book, user)

        expect(serialized_book).to include(
          id: book.id,
          title: book.title,
          author: book.author,
          genre: book.genre,
          isbn: book.isbn,
          total_copies: 2,
          available_copies: 1,
          available: true,
          current_user_borrowing: nil
        )
      end
    end

    context 'when all copies are borrowed' do
      before do
        2.times do |i|
          other_user = User.create!(
            email: "other#{i}@example.com",
            password: 'password',
            role: :member
          )
          Borrowing.create!(
            user: other_user,
            book: book,
            borrowed_at: Time.current,
            due_date: 2.weeks.from_now
          )
        end
      end

      it 'returns correct serialized data showing no availability' do
        serialized_book = BookSerializer.render(book, user)

        expect(serialized_book).to include(
          id: book.id,
          title: book.title,
          author: book.author,
          genre: book.genre,
          isbn: book.isbn,
          total_copies: 2,
          available_copies: 0,
          available: false,
          current_user_borrowing: nil
        )
      end
    end

    context 'when no current user is provided' do
      it 'returns correct serialized data without user-specific information' do
        serialized_book = BookSerializer.render(book)

        expect(serialized_book).to include(
          id: book.id,
          title: book.title,
          author: book.author,
          genre: book.genre,
          isbn: book.isbn,
          total_copies: 2,
          available_copies: 2,
          available: true,
          current_user_borrowing: nil
        )
      end
    end
  end
end 