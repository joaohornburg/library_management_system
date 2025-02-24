import React, { useState } from 'react'
import { useAuth } from '../contexts/AuthContext'
import BookForm from './BookForm'

const BookList = ({ books, onBooksChange }) => {
  const { currentUser, token, fetchWithAuth } = useAuth()
  const [editingBook, setEditingBook] = useState(null)

  const handleDelete = async (bookId) => {
    if (!window.confirm('Are you sure you want to delete this book?')) return

    try {
      const response = await fetch(`/api/v1/books/${bookId}`, {
        method: 'DELETE',
        headers: {
          'Authorization': token
        }
      })
      
      if (response.ok) {
        onBooksChange()
      }
    } catch (error) {
      console.error('Error deleting book:', error)
    }
  }

  const handleUpdate = async (bookData) => {
    try {
      const response = await fetch(`/api/v1/books/${editingBook.id}`, {
        method: 'PATCH',
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ book: bookData })
      })
      
      if (response.ok) {
        setEditingBook(null)
        onBooksChange()
      } else {
        const data = await response.json()
        alert(data.errors.join(', '))
      }
    } catch (error) {
      console.error('Error updating book:', error)
    }
  }

  const handleBorrow = async (bookId) => {
    try {
      const response = await fetchWithAuth('/api/v1/borrowings', {
        method: 'POST',
        body: JSON.stringify({ book_id: bookId })
      })

      if (response.ok) {
        const book = books.find(b => b.id === bookId)
        alert(`Successfully borrowed: ${book.title}`)
        onBooksChange()
      } else {
        const data = await response.json()
        alert(data.errors.join(', '))
      }
    } catch (error) {
      console.error('Error borrowing book:', error)
      alert('An error occurred while borrowing the book')
    }
  }

  return (
    <div className="row">
      {books.map(book => (
        <div key={book.id} className="col-md-6 col-lg-4 mb-4">
          <div className="card h-100">
            <div className="card-body">
              {editingBook?.id === book.id ? (
                <BookForm book={book} onSubmit={handleUpdate} />
              ) : (
                <>
                  <h5 className="card-title">{book.title}</h5>
                  <p className="card-text">
                    <strong>Author:</strong> {book.author}<br />
                    <strong>Genre:</strong> {book.genre}<br />
                    <strong>ISBN:</strong> {book.isbn}<br />
                    <strong>Total Copies:</strong> {book.total_copies}<br />
                    <strong>Available Copies:</strong> {book.available_copies}
                  </p>
                  
                  {currentUser?.role === 'librarian' ? (
                    <div className="btn-group">
                      <button 
                        onClick={() => setEditingBook(book)} 
                        className="btn btn-outline-primary"
                      >
                        Edit
                      </button>
                      <button 
                        onClick={() => handleDelete(book.id)} 
                        className="btn btn-outline-danger"
                      >
                        Delete
                      </button>
                    </div>
                  ) : (
                    <div>
                      {book.current_user_borrowing ? (
                        <p className="text-muted">
                          Due: {new Date(book.current_user_borrowing.due_date).toLocaleDateString()}
                        </p>
                      ) : book.available ? (
                        <button 
                          onClick={() => handleBorrow(book.id)}
                          className="btn btn-success"
                        >
                          Borrow
                        </button>
                      ) : (
                        <span className="text-danger">Not Available</span>
                      )}
                    </div>
                  )}
                </>
              )}
            </div>
          </div>
        </div>
      ))}
    </div>
  )
}

export default BookList 