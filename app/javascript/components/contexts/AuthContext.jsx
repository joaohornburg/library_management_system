import React, { createContext, useState, useContext } from 'react'

const AuthContext = createContext(null)

export const AuthProvider = ({ children }) => {
  const [token, setToken] = useState(localStorage.getItem('token'))
  const [currentUser, setCurrentUser] = useState(() => {
    const savedUser = localStorage.getItem('currentUser')
    return savedUser ? JSON.parse(savedUser) : null
  })

  const login = (authToken, user) => {
    console.log('Login called with token:', authToken, 'and user:', user)
    localStorage.setItem('token', authToken)
    localStorage.setItem('currentUser', JSON.stringify(user))
    setToken(authToken)
    setCurrentUser(user)
  }

  const logout = async () => {
    try {
      const response = await fetch('users/sign_out', {
        method: 'DELETE',
        headers: {
          Authorization: token,
          'Content-Type': 'application/json'
        }
      })

      if (!response.ok) {
        console.error('Logout failed:', response.status)
      }
    } catch (error) {
      console.error('Logout error:', error)
    } finally {
      localStorage.clear()
      setToken(null)
      setCurrentUser(null)
    }
  }

  const fetchWithAuth = async (url, options = {}) => {
    if (!token) {
      throw new Error('No authentication token available')
    }

    const headers = {
      'Content-Type': 'application/json',
      Accept: 'application/json',
      Authorization: token,
      ...options.headers,
    }

    return fetch(url, {
      ...options,
      headers,
    })
  }

  return (
    <AuthContext.Provider
      value={{
        token,
        currentUser,
        isLibrarian: currentUser?.role === 'librarian',
        login,
        logout,
        fetchWithAuth,
      }}
    >
      {children}
    </AuthContext.Provider>
  )
}

export const useAuth = () => useContext(AuthContext) 