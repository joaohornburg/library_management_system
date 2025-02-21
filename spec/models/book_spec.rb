# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:author) }
  it { should validate_numericality_of(:total_copies).is_greater_than_or_equal_to(0) }

  describe 'isbn uniqueness' do
    subject { Book.create(title: 'Test Book', author: 'Test Author', isbn: 'a1234567890') }
    it { should validate_uniqueness_of(:isbn) }
  end

  describe '.search' do
    let!(:book1) do
      Book.create!(title: 'Test Book', author: 'Test Author', isbn: 'a1234567890', total_copies: 1, genre: 'Test Genre')
    end
    let!(:book2) do
      Book.create!(title: 'Test Book 2', author: 'Test Author 2', isbn: 'b1234567890', total_copies: 1,
                   genre: 'Other Genre')
    end
    let!(:book3) do
      Book.create!(title: 'Clean Code', author: 'Uncle Bob', isbn: 'c1234567890', total_copies: 1, genre: 'Programming')
    end

    it 'returns all books when no search params are provided' do
      expect(Book.search({})).to eq([book1, book2, book3])
    end

    context 'when searching by title' do
      it 'returns books with matching title' do
        expect(Book.search(title: 'Test')).to eq([book1, book2])
      end
    end

    context 'when searching by author' do
      it 'returns books with matching author' do
        expect(Book.search(author: 'st Author')).to eq([book1, book2])
      end
    end

    context 'when searching by genre' do
      it 'returns books with matching genre' do
        expect(Book.search(genre: 'Test Genre')).to eq([book1])
      end
    end

    context 'when searching by title and genre  ' do
      it 'returns books with matching title and genre' do
        expect(Book.search(title: 'Test', genre: 'Test Genre')).to eq([book1])
      end
    end
  end
end
