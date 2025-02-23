import React, { useState, useEffect } from 'react'
import { useAuth } from '../contexts/AuthContext'

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

  if (!borrowings) return <div>Loading...</div>

  if (isLibrarian) {
    return (
      <div>
        <h2>All Borrowings</h2>
        {Object.entries(borrowings).map(([userEmail, userBorrowings]) => (
          <div key={userEmail} style={{ marginBottom: '20px' }}>
            <h3>User: {userEmail}</h3>
            <ul>
              {userBorrowings.map(borrowing => (
                <li key={borrowing.id} style={{ marginBottom: '10px' }}>
                  {borrowing.book_title} - Due: {new Date(borrowing.due_date).toLocaleDateString()}
                  {!borrowing.returned_at && (
                    <button 
                      onClick={() => handleReturn(borrowing.id)}
                      style={{ marginLeft: '10px' }}
                    >
                      Mark as Returned
                    </button>
                  )}
                </li>
              ))}
            </ul>
          </div>
        ))}
      </div>
    )
  }

  return (
    <div>
      <h2>Your Borrowings</h2>
      <ul>
        {borrowings.map(borrowing => (
          <li key={borrowing.id} style={{ marginBottom: '10px' }}>
            {borrowing.book_title} - Due: {new Date(borrowing.due_date).toLocaleDateString()}
          </li>
        ))}
      </ul>
    </div>
  )
}

export default Borrowings 