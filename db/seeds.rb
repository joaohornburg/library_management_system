# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts 'Creating users...'
User.find_or_create_by!(email: 'librarian@example.com') do |user|
  user.password = 'password123'
  user.role = :librarian
end

User.find_or_create_by!(email: 'member@example.com') do |user|
  user.password = 'password123'
  user.role = :member
end

puts 'Creating books...'
books_data = [
  {
    title: 'Clean Code: A Handbook of Agile Software Craftsmanship',
    author: 'Robert C. Martin',
    genre: 'Software Engineering',
    isbn: '9780132350884',
    total_copies: 3
  },
  {
    title: 'Clean Architecture: A Craftsman\'s Guide to Software Structure and Design',
    author: 'Robert C. Martin',
    genre: 'Software Engineering',
    isbn: '9780134494166',
    total_copies: 2
  },
  {
    title: 'Test Driven Development: By Example',
    author: 'Kent Beck',
    genre: 'Software Engineering',
    isbn: '9780321146533',
    total_copies: 3
  },
  {
    title: 'Refactoring: Improving the Design of Existing Code',
    author: 'Martin Fowler',
    genre: 'Software Engineering',
    isbn: '9780134757599',
    total_copies: 2
  },
  {
    title: 'Design Patterns: Elements of Reusable Object-Oriented Software',
    author: 'Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides',
    genre: 'Software Engineering',
    isbn: '9780201633610',
    total_copies: 2
  },
  {
    title: 'The Pragmatic Programmer: Your Journey to Mastery',
    author: 'David Thomas, Andrew Hunt',
    genre: 'Software Engineering',
    isbn: '9780135957059',
    total_copies: 3
  },
  {
    title: 'Extreme Programming Explained: Embrace Change',
    author: 'Kent Beck',
    genre: 'Agile Methodology',
    isbn: '9780321278654',
    total_copies: 2
  }
]

books_data.each do |book_data|
  Book.find_or_create_by!(isbn: book_data[:isbn]) do |book|
    book.assign_attributes(book_data)
    puts "Created book: #{book.title}"
  end
end

puts 'Seed completed successfully!'
