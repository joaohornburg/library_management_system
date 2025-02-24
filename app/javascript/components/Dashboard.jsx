import React, { useState, useEffect } from 'react'
import { useAuth } from './contexts/AuthContext'
import BorrowedBook from './borrowings/BorrowedBook'

const Dashboard = () => {
  const [dashboardData, setDashboardData] = useState(null)
  const [error, setError] = useState(null)
  const { fetchWithAuth, currentUser, isLibrarian } = useAuth()

  useEffect(() => {
    const fetchDashboardData = async () => {
      try {
        const response = await fetchWithAuth('/api/v1/dashboard')

        if (response.ok) {
          const data = await response.json()
          setDashboardData(data)
        } else {
          setError('Failed to fetch dashboard data')
        }
      } catch (err) {
        setError('An error occurred while fetching dashboard data')
      }
    }

    fetchDashboardData()
  }, [fetchWithAuth])

  if (error) return <div className="error">{error}</div>
  if (!dashboardData) return <div>Loading...</div>

  return (
    <div className="dashboard container py-4">
      {isLibrarian ? (
        <div className="librarian-dashboard">
          <div className="row mb-4">
            <div className="col-md-6">
              <div className="card">
                <div className="card-body">
                  <h3 className="card-title">Total Books</h3>
                  <p className="display-4">{dashboardData.total_books}</p>
                </div>
              </div>
            </div>
            <div className="col-md-6">
              <div className="card">
                <div className="card-body">
                  <h3 className="card-title">Total Borrowed Books</h3>
                  <p className="display-4">{dashboardData.total_borrowed_books}</p>
                </div>
              </div>
            </div>
          </div>

          <div className="row">
            <div className="col-md-6 mb-4">
              <div className="card">
                <div className="card-header">
                  <h3 className="h5 mb-0">Books Due Today</h3>
                </div>
                <div className="card-body">
                  {dashboardData.books_due_today.map((borrowing, index) => (
                    <BorrowedBook
                      key={index}
                      borrowing={{
                        id: borrowing.id,
                        book_title: borrowing.book_title,
                        due_date: new Date().toISOString(),
                        user_email: borrowing.user_email
                      }}
                      isLibrarian={true}
                      showReturnButton={false}
                    />
                  ))}
                </div>
              </div>
            </div>

            <div className="col-md-6 mb-4">
              <div className="card">
                <div className="card-header">
                  <h3 className="h5 mb-0">Overdue Books</h3>
                </div>
                <div className="card-body">
                  {dashboardData.overdue_borrowings.map((borrowing, index) => (
                    <BorrowedBook
                      key={index}
                      borrowing={{
                        id: borrowing.id,
                        book_title: borrowing.book_title,
                        due_date: borrowing.due_date,
                        user_email: borrowing.user_email,
                        days_overdue: borrowing.days_overdue
                      }}
                      isLibrarian={true}
                      showReturnButton={false}
                    />
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>
      ) : (
        <div className="member-dashboard">
          <div className="row">
            <div className="col-12">
              <div className="card mb-4">
                <div className="card-header">
                  <h3 className="h5 mb-0">Your Borrowed Books</h3>
                </div>
                <div className="card-body">
                  {dashboardData.current_borrowings.map((borrowing, index) => (
                    <BorrowedBook
                      key={index}
                      borrowing={borrowing}
                      isLibrarian={false}
                    />
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default Dashboard 