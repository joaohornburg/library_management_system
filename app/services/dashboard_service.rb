# frozen_string_literal: true

class DashboardService
  def initialize(user)
    @user = user
  end

  def stats
    if @user.librarian?
      librarian_stats
    else
      member_stats
    end
  end

  private

  def librarian_stats
    {
      total_books: Book.count,
      total_borrowed_books: Borrowing.active.count,
      books_due_today:,
      overdue_borrowings: overdue_borrowings_with_users
    }
  end

  def member_stats
    {
      current_borrowings:,
      overdue_borrowings: user_overdue_borrowings
    }
  end

  def books_due_today
    Borrowing.due_today.includes(:book, :user).map do |borrowing|
      {
        book_title: borrowing.book.title,
        user_email: borrowing.user.email,
        due_date: borrowing.due_date
      }
    end
  end

  def overdue_borrowings_with_users
    Borrowing.overdue.includes(:book, :user).map do |borrowing|
      {
        book_title: borrowing.book.title,
        user_email: borrowing.user.email,
        due_date: borrowing.due_date,
        days_overdue: ((Time.current - borrowing.due_date) / 1.day).to_i
      }
    end
  end

  def current_borrowings
    @user.borrowings.active.includes(:book).map do |borrowing|
      {
        book_title: borrowing.book.title,
        due_date: borrowing.due_date,
        overdue: borrowing.overdue?
      }
    end
  end

  def user_overdue_borrowings
    @user.borrowings.overdue.includes(:book).map do |borrowing|
      {
        book_title: borrowing.book.title,
        due_date: borrowing.due_date,
        days_overdue: ((Time.current - borrowing.due_date) / 1.day).to_i
      }
    end
  end
end
