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
end
