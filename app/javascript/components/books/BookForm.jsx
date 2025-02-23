import React, { useState } from 'react'

const BookForm = ({ book, onSubmit }) => {
  const [formData, setFormData] = useState({
    title: book?.title || '',
    author: book?.author || '',
    genre: book?.genre || '',
    isbn: book?.isbn || '',
    total_copies: book?.total_copies || 1
  })

  const handleSubmit = (e) => {
    e.preventDefault()
    onSubmit(formData)
  }

  const handleChange = (e) => {
    const value = e.target.type === 'number' 
      ? parseInt(e.target.value, 10) 
      : e.target.value

    setFormData({
      ...formData,
      [e.target.name]: value
    })
  }

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>Title:</label>
        <input
          type="text"
          name="title"
          value={formData.title}
          onChange={handleChange}
          required
        />
      </div>
      <div>
        <label>Author:</label>
        <input
          type="text"
          name="author"
          value={formData.author}
          onChange={handleChange}
          required
        />
      </div>
      <div>
        <label>Genre:</label>
        <input
          type="text"
          name="genre"
          value={formData.genre}
          onChange={handleChange}
        />
      </div>
      <div>
        <label>ISBN:</label>
        <input
          type="text"
          name="isbn"
          value={formData.isbn}
          onChange={handleChange}
          required
        />
      </div>
      <div>
        <label>Total Copies:</label>
        <input
          type="number"
          name="total_copies"
          value={formData.total_copies}
          onChange={handleChange}
          min="0"
          required
        />
      </div>
      <button type="submit">{book ? 'Update Book' : 'Add Book'}</button>
    </form>
  )
}

export default BookForm 