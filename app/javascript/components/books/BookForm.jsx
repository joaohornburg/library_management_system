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
    <form onSubmit={handleSubmit} className="p-4 bg-light rounded shadow-sm">
      <div className="row g-3">
        <div className="col-md-6">
          <div className="form-group">
            <label htmlFor="title" className="form-label">Title:</label>
            <input
              type="text"
              id="title"
              name="title"
              className="form-control"
              value={formData.title}
              onChange={handleChange}
              required
            />
          </div>
        </div>

        <div className="col-md-6">
          <div className="form-group">
            <label htmlFor="author" className="form-label">Author:</label>
            <input
              type="text"
              id="author"
              name="author"
              className="form-control"
              value={formData.author}
              onChange={handleChange}
              required
            />
          </div>
        </div>

        <div className="col-md-6">
          <div className="form-group">
            <label htmlFor="genre" className="form-label">Genre:</label>
            <input
              type="text"
              id="genre"
              name="genre"
              className="form-control"
              value={formData.genre}
              onChange={handleChange}
            />
          </div>
        </div>

        <div className="col-md-6">
          <div className="form-group">
            <label htmlFor="isbn" className="form-label">ISBN:</label>
            <input
              type="text"
              id="isbn"
              name="isbn"
              className="form-control"
              value={formData.isbn}
              onChange={handleChange}
              required
            />
          </div>
        </div>

        <div className="col-md-6">
          <div className="form-group">
            <label htmlFor="total_copies" className="form-label">Total Copies:</label>
            <input
              type="number"
              id="total_copies"
              name="total_copies"
              className="form-control"
              value={formData.total_copies}
              onChange={handleChange}
              min="0"
              required
            />
          </div>
        </div>
      </div>

      <div className="row mt-4">
        <div className="col-12 text-end">
          <button 
            type="submit" 
            className="btn btn-primary"
          >
            {book ? 'Update Book' : 'Add Book'}
          </button>
        </div>
      </div>
    </form>
  )
}

export default BookForm 