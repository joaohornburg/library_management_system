# frozen_string_literal: true

class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :borrowed_at, presence: true
  validates :due_date, presence: true
  validate :book_must_be_available, on: :create

  scope :active, -> { where(returned_at: nil) }

  private

  def book_must_be_available
    return unless book.borrowings.active.count >= book.total_copies

      errors.add(:base, 'Book is not available for borrowing')
  end
end
