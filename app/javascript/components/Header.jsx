import React from 'react'
import { useAuth } from './contexts/AuthContext'
import { useNavigate } from 'react-router-dom'

const Header = () => {
  const { currentUser, logout } = useAuth()
  const navigate = useNavigate()

  const handleLogout = () => {
    logout()
    navigate('/login')
  }

  return (
    <div className="dashboard-header">
      <h2>Welcome, {currentUser.email}</h2>
      <button onClick={handleLogout} className="logout-button">Logout</button>
    </div>
  )
}

export default Header 