class BorrowingSerializer
  def self.render(borrowing)
    {
      id: borrowing.id,
      book_title: borrowing.book.title,
      borrowed_at: borrowing.borrowed_at,
      due_date: borrowing.due_date,
      returned_at: borrowing.returned_at,
      user_email: borrowing.user.email
    }
  end
end 