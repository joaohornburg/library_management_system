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
    <div className="container py-4">
      <h2 className="mb-4">Books</h2>
      <div className="row">
        <div className="col-12 mb-4">
          <SearchForm onSearch={handleSearch} />
        </div>
      </div>
      
      {isLibrarian && (
        <div className="librarian-controls">
          <button 
            onClick={() => setShowAddForm(!showAddForm)}
            className={`btn ${showAddForm ? 'btn-danger' : 'btn-primary'}`}
          >
            {showAddForm ? 'Cancel' : 'Add New Book'}
          </button>
          {showAddForm && (
            <div className="mt-3">
              <BookForm onSubmit={handleAddBook} />
            </div>
          )}
        </div>
      )}
      
      <div className="row">
        <div className="col-12">
          <BookList 
            books={books} 
            onBooksChange={() => fetchBooks(searchParams)}
            isLibrarian={isLibrarian}
          />
        </div>
      </div>
    </div>
  )
}

export default Books 