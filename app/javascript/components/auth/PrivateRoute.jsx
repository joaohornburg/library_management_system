import React from 'react'
import { Navigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import Layout from '../Layout'

const PrivateRoute = ({ element }) => {
  const { token, currentUser } = useAuth()
  
  if (!token || !currentUser) {
    return <Navigate to="/login" replace />
  }

  return <Layout>{element}</Layout>
}

export default PrivateRoute 