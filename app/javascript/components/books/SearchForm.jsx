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
    <form onSubmit={handleSubmit}>
      <div>
        <input
          type="text"
          name="title"
          placeholder="Search by title"
          value={searchParams.title}
          onChange={handleChange}
        />
        <input
          type="text"
          name="author"
          placeholder="Search by author"
          value={searchParams.author}
          onChange={handleChange}
        />
        <input
          type="text"
          name="genre"
          placeholder="Search by genre"
          value={searchParams.genre}
          onChange={handleChange}
        />
        <button type="submit">Search</button>
      </div>
    </form>
  )
}

export default SearchForm 