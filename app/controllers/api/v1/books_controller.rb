# frozen_string_literal: true

module Api
  module V1
    class BooksController < Api::V1::BaseController
      before_action :set_book, only: %i[show update destroy]

      def index
        @books = Book.search(search_params)
        authorize @books
        render json: @books
      end

      def show
        authorize @book
        render json: @book
      end

      def create
        @book = Book.new(book_params)
        authorize @book

        if @book.save
          render json: @book, status: :created
        else
          render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize @book

        if @book.update(book_params)
          render json: @book
        else
          render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @book
        @book.destroy
        head :no_content
      end

      private

      def set_book
        @book = Book.find(params[:id])
      end

      def book_params
        params.require(:book).permit(:title, :author, :genre, :isbn, :total_copies)
      end

      def search_params
        params.permit(:title, :author, :genre)
      end
    end
  end
end
