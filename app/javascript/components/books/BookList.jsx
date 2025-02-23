import React, { useState } from 'react'
import { useAuth } from '../contexts/AuthContext'
import BookForm from './BookForm'

const BookList = ({ books, onBooksChange }) => {
  const { currentUser, token } = useAuth()
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

  return (
    <div>
      {books.map(book => (
        <div key={book.id} style={{ marginBottom: '20px', padding: '10px', border: '1px solid #ccc' }}>
          {editingBook?.id === book.id ? (
            <BookForm book={book} onSubmit={handleUpdate} />
          ) : (
            <>
              <h3>{book.title}</h3>
              <p>Author: {book.author}</p>
              <p>Genre: {book.genre}</p>
              <p>ISBN: {book.isbn}</p>
              <p>Total Copies: {book.total_copies}</p>
              
              {currentUser?.role === 'librarian' && (
                <div>
                  <button onClick={() => setEditingBook(book)}>Edit</button>
                  <button onClick={() => handleDelete(book.id)}>Delete</button>
                </div>
              )}
            </>
          )}
        </div>
      ))}
    </div>
  )
}

export default BookList 