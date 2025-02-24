import React, { useState, useEffect } from 'react'
import { useAuth } from '../contexts/AuthContext'
import BorrowedBook from './BorrowedBook'

const Borrowings = () => {
  const { currentUser, fetchWithAuth, isLibrarian } = useAuth()
  const [borrowings, setBorrowings] = useState(null)

  useEffect(() => {
    fetchBorrowings()
  }, [])

  const fetchBorrowings = async () => {
    try {
      const response = await fetchWithAuth('/api/v1/borrowings')
      if (response.ok) {
        const data = await response.json()
        setBorrowings(data)
      }
    } catch (error) {
      console.error('Error fetching borrowings:', error)
    }
  }

  const handleReturn = async (borrowingId) => {
    try {
      const response = await fetchWithAuth(`/api/v1/borrowings/${borrowingId}/return`, {
        method: 'PATCH'
      })

      if (response.ok) {
        fetchBorrowings()
      } else {
        const data = await response.json()
        alert(data.errors.join(', '))
      }
    } catch (error) {
      console.error('Error returning book:', error)
    }
  }

  if (!borrowings) return (
    <div className="container py-4">
      <div className="spinner-border text-primary" role="status">
        <span className="visually-hidden">Loading...</span>
      </div>
    </div>
  )

  if (isLibrarian) {
    return (
      <div className="container py-4">
        <h2 className="mb-4">All Active Borrowings</h2>
        <div className="row">
          {Object.entries(borrowings).map(([userEmail, userBorrowings]) => (
            <div key={userEmail} className="col-12 col-lg-6 mb-4">
              <div className="card">
                <div className="card-header">
                  <h3 className="h5 mb-0">User: {userEmail}</h3>
                </div>
                <div className="card-body">
                  {userBorrowings.map(borrowing => (
                    <BorrowedBook
                      key={borrowing.id}
                      borrowing={borrowing}
                      onReturn={handleReturn}
                      isLibrarian={isLibrarian}
                    />
                  ))}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    )
  }

  return (
    <div className="container py-4">
      <h2 className="mb-4">Your Borrowings</h2>
      <div className="row">
        {borrowings.map(borrowing => (
          <div key={borrowing.id} className="col-12 col-md-6 col-lg-4">
            <BorrowedBook
              borrowing={borrowing}
              onReturn={handleReturn}
              isLibrarian={isLibrarian}
            />
          </div>
        ))}
      </div>
    </div>
  )
}

export default Borrowings 