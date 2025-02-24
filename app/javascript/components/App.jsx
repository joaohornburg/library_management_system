import React from 'react'
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import Login from './auth/Login'
import Register from './auth/Register'
import Dashboard from './Dashboard'
import Books from './books/Books'
import Borrowings from './borrowings/Borrowings'
import { AuthProvider } from './contexts/AuthContext'
import PrivateRoute from './auth/PrivateRoute'

const App = () => {
  console.log('App component rendering')
  return (
    <AuthProvider>
      <Router>
        <div className="container-fluid">
          <Routes>
            <Route path="/login" element={<Login />} />
            <Route path="/register" element={<Register />} />
            <Route
              path="/dashboard"
              element={<PrivateRoute element={<Dashboard />} />}
            />
            <Route
              path="/books"
              element={<PrivateRoute element={<Books />} />}
            />
            <Route
              path="/borrowings"
              element={<PrivateRoute element={<Borrowings />} />}
            />
            <Route path="/" element={<Navigate to="/dashboard" />} />
          </Routes>
        </div>
      </Router>
    </AuthProvider>
  )
}

export default App 