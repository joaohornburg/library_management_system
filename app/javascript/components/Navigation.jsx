import React from 'react'
import { Link, useLocation, useNavigate } from 'react-router-dom'
import { useAuth } from './contexts/AuthContext'

const Navigation = () => {
  const location = useLocation()
  const navigate = useNavigate()
  const { currentUser, logout } = useAuth()

  const isActive = (path) => {
    return location.pathname === path ? 'active' : ''
  }

  const handleLogout = () => {
    logout()
    navigate('/login')
  }

  return (
    <nav className="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
      <div className="container-fluid">
        <Link className="navbar-brand" to="/">Library System</Link>
        
        <button 
          className="navbar-toggler" 
          type="button" 
          data-bs-toggle="collapse" 
          data-bs-target="#navbarNav" 
          aria-controls="navbarNav" 
          aria-expanded="false" 
          aria-label="Toggle navigation"
        >
          <span className="navbar-toggler-icon"></span>
        </button>

        <div className="collapse navbar-collapse" id="navbarNav">
          <ul className="navbar-nav me-auto">
            <li className="nav-item">
              <Link 
                to="/dashboard" 
                className={`nav-link ${isActive('/dashboard')}`}
              >
                Dashboard
              </Link>
            </li>
            <li className="nav-item">
              <Link 
                to="/books" 
                className={`nav-link ${isActive('/books')}`}
              >
                Books
              </Link>
            </li>
            <li className="nav-item">
              <Link 
                to="/borrowings" 
                className={`nav-link ${isActive('/borrowings')}`}
              >
                Borrowings
              </Link>
            </li>
          </ul>
          
          <span className="navbar-text me-3">
            Welcome, {currentUser?.email}
          </span>
          <button 
            onClick={handleLogout} 
            className="btn btn-outline-light"
          >
            Logout
          </button>
        </div>
      </div>
    </nav>
  )
}

export default Navigation