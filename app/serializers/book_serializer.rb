class BookSerializer
  def self.render(book, current_user = nil)
    current_borrowing = current_user ? book.borrowings.active.find_by(user: current_user) : nil

    {
      id: book.id,
      title: book.title,
      author: book.author,
      genre: book.genre,
      isbn: book.isbn,
      total_copies: book.total_copies,
      available_copies: book.total_copies - book.borrowings.active.count,
      available: book.total_copies > book.borrowings.active.count,
      current_user_borrowing: current_borrowing ? {
        due_date: current_borrowing.due_date
      } : nil
    }
  end
end 