import React, { useState, useEffect } from 'react'
import { useAuth } from './contexts/AuthContext'

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
          console.log(data)
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
    <div className="dashboard">
      <h2>Welcome, {currentUser.email}</h2>
      
      {isLibrarian ? (
        <div className="librarian-dashboard">
          <div className="stats">
            <div className="stat-box">
              <h3>Total Books</h3>
              <p>{dashboardData.total_books}</p>
            </div>
            <div className="stat-box">
              <h3>Total Borrowed Books</h3>
              <p>{dashboardData.total_borrowed_books}</p>
            </div>
          </div>

          <div className="books-due">
            <h3>Books Due Today</h3>
            <ul>
              {dashboardData.books_due_today.map((item, index) => (
                <li key={index}>
                  {item.book_title} - {item.user_email}
                </li>
              ))}
            </ul>
          </div>

          <div className="overdue-books">
            <h3>Overdue Books</h3>
            <ul>
              {dashboardData.overdue_borrowings.map((item, index) => (
                <li key={index}>
                  {item.book_title} - {item.user_email} ({item.days_overdue} days overdue)
                </li>
              ))}
            </ul>
          </div>
        </div>
      ) : (
        <div className="member-dashboard">
          <div className="current-borrowings">
            <h3>Your Borrowed Books</h3>
            <ul>
              {dashboardData.current_borrowings.map((item, index) => (
                <li key={index} className={item.overdue ? 'overdue' : ''}>
                  {item.book_title} - Due: {new Date(item.due_date).toLocaleDateString()}
                </li>
              ))}
            </ul>
          </div>

          <div className="overdue-books">
            <h3>Overdue Books</h3>
            <ul>
              {dashboardData.overdue_borrowings.map((item, index) => (
                <li key={index}>
                  {item.book_title} - {item.days_overdue} days overdue
                </li>
              ))}
            </ul>
          </div>
        </div>
      )}
    </div>
  )
}

export default Dashboard 