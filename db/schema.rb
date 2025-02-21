# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_250_221_182_224) do
  create_table 'books', force: :cascade do |t|
    t.string 'title'
    t.string 'author'
    t.string 'genre'
    t.string 'isbn'
    t.integer 'total_copies'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['isbn'], name: 'index_books_on_isbn', unique: true
  end

  create_table 'borrowings', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.integer 'book_id', null: false
    t.datetime 'borrowed_at'
    t.datetime 'due_date'
    t.datetime 'returned_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['book_id'], name: 'index_borrowings_on_book_id'
    t.index %w[user_id book_id], name: 'index_borrowings_on_user_and_book_active', unique: true,
                                 where: 'returned_at IS NULL'
    t.index ['user_id'], name: 'index_borrowings_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'role', default: 0, null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'borrowings', 'books'
  add_foreign_key 'borrowings', 'users'
end
