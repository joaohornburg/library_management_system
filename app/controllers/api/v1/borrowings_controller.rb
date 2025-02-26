# frozen_string_literal: true

module Api
  module V1
    class BorrowingsController < Api::V1::BaseController
      before_action :authenticate_user!
      before_action :set_borrowing, only: [:return]

      # POST /api/v1/borrowings
      def create
        borrowing = BorrowingService.new(current_user).create_borrowing(params[:book_id])
        authorize borrowing

        if borrowing.save
          render json: borrowing, status: :created
        else
          render json: { errors: borrowing.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/borrowings/:id/return
      def return
        authorize @borrowing
        returned_borrowing = BorrowingService.new(current_user).return_borrowing(@borrowing)

        if returned_borrowing.save
          render json: returned_borrowing, status: :ok
        else
          render json: { errors: returned_borrowing.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def index
        if current_user.librarian?
          @borrowings = Borrowing.active.includes(:user, :book)
          borrowings_by_user = @borrowings.group_by { |b| b.user.email }.transform_values do |borrowings|
            borrowings.map { |b| BorrowingSerializer.render(b) }
          end
          render json: borrowings_by_user
        else
          @borrowings = current_user.borrowings.includes(:book)
          render json: @borrowings.map { |b| BorrowingSerializer.render(b) }
        end
      end

      private

      def set_borrowing
        @borrowing = Borrowing.find(params[:id])
      end
    end
  end
end
