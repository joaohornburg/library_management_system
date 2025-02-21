# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:librarian) { User.create!(email: 'librarian@example.com', password: 'password', role: :librarian) }
  let(:member) { User.create!(email: 'member@example.com', password: 'password', role: :member) }

  let(:valid_attributes) do
    {
      title: 'Test Book',
      author: 'Test Author',
      genre: 'Fiction',
      isbn: '1234567890',
      total_copies: 5
    }
  end

  let(:invalid_attributes) do
    {
      title: '',
      author: '',
      isbn: '',
      total_copies: -1
    }
  end

  describe 'POST #create' do
    context 'when user is a librarian' do
      before { sign_in librarian }

      context 'with valid attributes' do
        it 'creates a new book' do
          expect do
            post :create, params: { book: valid_attributes }, format: :json
          end.to change(Book, :count).by(1)
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid attributes' do
        it 'returns unprocessable entity' do
          post :create, params: { book: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when user is a member' do
      before { sign_in member }

      it 'returns unauthorized' do
        post :create, params: { book: valid_attributes }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        post :create, params: { book: valid_attributes }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is a librarian' do
      before { sign_in librarian }

      context 'with valid attributes' do
        it 'updates the book' do
          book = Book.create! valid_attributes
          patch :update, params: { id: book.id, book: { title: 'New Title' } }, format: :json
          expect(response).to have_http_status(:ok)
          book.reload
          expect(book.title).to eq('New Title')
        end
      end

      context 'with invalid attributes' do
        it 'returns unprocessable entity' do
          book = Book.create! valid_attributes
          patch :update, params: { id: book.id, book: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when user is a member' do
      before { sign_in member }

      it 'returns unauthorized' do
        book = Book.create! valid_attributes
        patch :update, params: { id: book.id, book: { title: 'New Title' } }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        book = Book.create! valid_attributes
        patch :update, params: { id: book.id, book: { title: 'New Title' } }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is a librarian' do
      before { sign_in librarian }

      it 'destroys the book' do
        book = Book.create! valid_attributes
        expect do
          delete :destroy, params: { id: book.id }, format: :json
        end.to change(Book, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when user is a member' do
      before { sign_in member }

      it 'returns unauthorized' do
        book = Book.create! valid_attributes
        delete :destroy, params: { id: book.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        book = Book.create! valid_attributes
        delete :destroy, params: { id: book.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #show' do
    shared_examples 'returns a book' do
      it 'returns a book' do
        book = Book.create! valid_attributes
        get :show, params: { id: book.id }, format: :json
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(book.to_json)
      end
    end

    context 'when user is a librarian' do
      before { sign_in librarian }
      it_behaves_like 'returns a book'
    end

    context 'when user is a member' do
      before { sign_in member }
      it_behaves_like 'returns a book'
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        book = Book.create! valid_attributes
        get :show, params: { id: book.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #index' do
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

    context 'when user is authenticated' do
      before { sign_in member }

      it 'returns all books when no search params are provided' do
        get :index, format: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).length).to eq(3)
      end

      it 'returns filtered books when search params are provided' do
        get :index, params: { title: 'Test' }, format: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).length).to eq(2)
      end
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        get :index, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
