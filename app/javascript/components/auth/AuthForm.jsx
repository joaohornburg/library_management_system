import React from 'react'

const AuthForm = ({ children, title }) => {
  return (
    <div className="container">
      <div className="row justify-content-center align-items-center min-vh-100">
        <div className="col-md-6 col-lg-4">
          <div className="card shadow">
            <div className="card-body">
              <h2 className="card-title text-center mb-4">{title}</h2>
              {children}
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default AuthForm 