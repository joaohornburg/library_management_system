# frozen_string_literal: true

class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :borrowed_at, presence: true
  validates :due_date, presence: true
  validate :book_must_be_available, on: :create

  scope :active, -> { where(returned_at: nil) }
  scope :overdue, -> { active.where('due_date < ?', Time.current) }
  scope :due_today, lambda {
                      active.where('due_date BETWEEN ? AND ?', Time.current.beginning_of_day, Time.current.end_of_day)
                    }

  def overdue?
    due_date < Time.current.beginning_of_day && !returned_at
  end

  private

  def book_must_be_available
    return unless book.borrowings.active.count >= book.total_copies

    errors.add(:base, 'Book is not available for borrowing')
  end
end
