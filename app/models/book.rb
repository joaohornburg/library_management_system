# frozen_string_literal: true

class Book < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true
  validates :isbn, uniqueness: true, allow_nil: false
  validates :total_copies, numericality: { greater_than_or_equal_to: 0 }
end
