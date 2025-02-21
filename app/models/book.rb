# frozen_string_literal: true

class Book < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true
  validates :isbn, uniqueness: true, allow_nil: false
  validates :total_copies, numericality: { greater_than_or_equal_to: 0 }

  scope :search, lambda { |params|
    results = all
    results = results.where('LOWER(title) LIKE LOWER(?)', "%#{params[:title]}%") if params[:title].present?
    results = results.where('LOWER(author) LIKE LOWER(?)', "%#{params[:author]}%") if params[:author].present?
    results = results.where('LOWER(genre) LIKE LOWER(?)', "%#{params[:genre]}%") if params[:genre].present?
    results
  }
end
