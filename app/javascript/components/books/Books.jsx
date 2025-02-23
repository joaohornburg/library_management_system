import React, { useState, useEffect } from 'react'
import { useAuth } from '../contexts/AuthContext'
import BookForm from './BookForm'
import BookList from './BookList'
import SearchForm from './SearchForm'

const Books = () => {
  const [books, setBooks] = useState([])
  const [showAddForm, setShowAddForm] = useState(false)
  const [searchParams, setSearchParams] = useState({
    title: '',
    author: '',
    genre: ''
  })
  const { fetchWithAuth, isLibrarian } = useAuth()

  const fetchBooks = async (params = {}) => {
    try {
      const filteredParams = Object.fromEntries(
        Object.entries(params).filter(([_, value]) => value.trim() !== '')
      )
      const queryString = new URLSearchParams(filteredParams).toString()
      const response = await fetchWithAuth(`/api/v1/books?${queryString}`)

      if (response.ok) {
        const data = await response.json()
        setBooks(data)
      }
    } catch (error) {
      console.error('Error fetching books:', error)
    }
  }

  useEffect(() => {
    fetchBooks(searchParams)
  }, [searchParams])

  const handleSearch = (params) => {
    setSearchParams(params)
  }

  const handleAddBook = async (bookData) => {
    try {
      const response = await fetchWithAuth('/api/v1/books', {
        method: 'POST',
        body: JSON.stringify({ book: bookData })
      })
      
      if (response.ok) {
        fetchBooks(searchParams)
        setShowAddForm(false)
      } else {
        const data = await response.json()
        alert(data.errors.join(', '))
      }
    } catch (error) {
      console.error('Error adding book:', error)
    }
  }

  return (
    <div>
      <h2>Books</h2>
      <SearchForm onSearch={handleSearch} />
      
      {isLibrarian && (
        <div className="librarian-controls">
          <button 
            onClick={() => setShowAddForm(!showAddForm)}
            className="add-book-button"
          >
            {showAddForm ? 'Cancel' : 'Add New Book'}
          </button>
          {showAddForm && <BookForm onSubmit={handleAddBook} />}
        </div>
      )}
      
      <BookList 
        books={books} 
        onBooksChange={() => fetchBooks(searchParams)}
        isLibrarian={isLibrarian}
      />
    </div>
  )
}

export default Books 