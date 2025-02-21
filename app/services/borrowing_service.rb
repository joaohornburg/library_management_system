# frozen_string_literal: true

class BorrowingService
  def initialize(user)
    @user = user
  end

  def create_borrowing(book_id)
    borrowing = @user.borrowings.build(book_id:)
    borrowing.borrowed_at = Time.current
    borrowing.due_date = 2.weeks.from_now

    borrowing
  end

  def return_borrowing(borrowing)
    borrowing.returned_at = Time.current
    borrowing
  end
end
