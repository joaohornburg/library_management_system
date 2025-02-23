import React from 'react'
import { Link, useLocation } from 'react-router-dom'

const Navigation = () => {
  const location = useLocation()

  const isActive = (path) => {
    return location.pathname === path ? 'active' : ''
  }

  return (
    <nav className="main-navigation">
      <ul>
        <li className={isActive('/dashboard')}>
          <Link to="/dashboard">Dashboard</Link>
        </li>
        <li className={isActive('/books')}>
          <Link to="/books">Books</Link>
        </li>
        <li className={isActive('/borrowings')}>
          <span>Borrowings</span>
        </li>
      </ul>
    </nav>
  )
}

export default Navigation 