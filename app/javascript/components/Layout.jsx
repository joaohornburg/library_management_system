import React from 'react'
import Navigation from './Navigation'

const Layout = ({ children }) => {
  return (
    <div>
      <Navigation />
      <main style={{ padding: '0 20px' }}>
        {children}
      </main>
    </div>
  )
}

export default Layout 