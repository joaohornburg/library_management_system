import React from 'react'
import Header from './Header'
import Navigation from './Navigation'

const Layout = ({ children }) => {
  return (
    <div>
      <Header />
      <Navigation />
      <main style={{ padding: '0 20px' }}>
        {children}
      </main>
    </div>
  )
}

export default Layout 