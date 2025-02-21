# frozen_string_literal: true

class BorrowingPolicy < ApplicationPolicy
  def create?
    # Requirements state that: "Member users should be able to borrow a book if it's available."
    # Assuming that librarians can't borrow books.
    user.member?
  end

  def return?
    user.librarian?
  end
end
