import React from 'react'

const BorrowedBook = ({ borrowing, onReturn, isLibrarian, showReturnButton = true }) => {
  const dueDate = new Date(borrowing.due_date)
  const isOverdue = dueDate < new Date()

  return (
    <div className="card mb-3">
      <div className="card-body">
        <h5 className="card-title">{borrowing.book_title}</h5>
        <p className={`card-text ${isOverdue ? 'text-danger' : ''}`}>
          Due: {dueDate.toLocaleDateString()}
        </p>
        {isLibrarian && showReturnButton && !borrowing.returned_at && (
          <button 
            onClick={() => onReturn(borrowing.id)}
            className="btn btn-outline-success"
          >
            Mark as Returned
          </button>
        )}
      </div>
    </div>
  )
}

export default BorrowedBook 