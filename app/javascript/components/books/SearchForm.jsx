import React, { useState } from 'react'

const SearchForm = ({ onSearch }) => {
  const [searchParams, setSearchParams] = useState({
    title: '',
    author: '',
    genre: ''
  })

  const handleSubmit = (e) => {
    e.preventDefault()
    onSearch(searchParams)
  }

  const handleChange = (e) => {
    setSearchParams({
      ...searchParams,
      [e.target.name]: e.target.value
    })
  }

  return (
    <form onSubmit={handleSubmit} className="bg-light p-4 rounded shadow-sm">
      <div className="row g-3">
        <div className="col-md-3">
          <div className="form-group">
            <input
              type="text"
              name="title"
              className="form-control"
              placeholder="Search by title"
              value={searchParams.title}
              onChange={handleChange}
            />
          </div>
        </div>
        <div className="col-md-3">
          <div className="form-group">
            <input
              type="text"
              name="author"
              className="form-control"
              placeholder="Search by author"
              value={searchParams.author}
              onChange={handleChange}
            />
          </div>
        </div>
        <div className="col-md-3">
          <div className="form-group">
            <input
              type="text"
              name="genre"
              className="form-control"
              placeholder="Search by genre"
              value={searchParams.genre}
              onChange={handleChange}
            />
          </div>
        </div>
        <div className="col-md-2">
          <button type="submit" className="btn btn-primary w-100">
            Search
          </button>
        </div>
      </div>
    </form>
  )
}

export default SearchForm 