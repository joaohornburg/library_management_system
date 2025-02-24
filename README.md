# README

This is a simple library management system built with Ruby on Rails and React.

## Setup

```
bundle install
rails db:migrate
rails db:seed
yarn install
```

## Run

```
./bin/dev
```

## Test

```
bundle exec rspec spec
```

## Thought Process

- First, I analyzed the requirements to decide on the architecture of the system and which gems to use.
- Since the frontend was optional but strongly recommended, I decided to use traditional Rails (instead of the API-only approach—which would have been more appropriate for a pure API). This allowed me to add React directly inside the Rails app.
- I chose to serve React from Rails instead of having a separate React app because of the simplicity of this setup, especially for a small app like this and given the short time available for the project.
- I decided to use React because it is the framework I'm most familiar with.
- I used Devise for authentication since it's a well-known gem that provides a simple and secure way to handle user authentication. As this was going to be a React app — not a pure API that would use OAuth — I opted for JWT and devise-jwt. Later on, I realized that Devise may have been too heavyweight and opinionated for this app, as it includes many features geared toward traditional session-based authentication. But as it was already configured and working, I decided to keep it.
- I used Pundit for authorization because it's simple and just works.
- I implemented the features in the order they were listed in the requirements. I started with users (authentication and registration), then books, then borrowings, and finally the dashboard. I TDD'ed the features as I went along until I finished the whole backend.
- Once the backend was finished, I started on the frontend. I followed the same order as the backend, but I didn't TDD the frontend since I'm still new to React and this was more of a "putting pieces together" exercise.
- The frontend implementation led to some additions to the backend, particularly in borrowings, due to new requirements that I discovered while working on the frontend. For example, including the availability of books and displaying the current user's status in the Books#index.
- After this was done, I proceeded with testing.
- After testing I realized that the frontend wasn't responsive and that the layout was not optimal. So I added Bootstrap to the project and refactored the frontend to be more responsive and user-friendly. I decided to use Bootstrap because of it's built-in grid system and because I'm familiar with it.

### Future Improvements

- Add pagination to the Books#index
- Add tests for the frontend
- Allow the librarian to group Borrowings by book as well as by user
- Add a button for the librarian to lend a book to a user - I think this would be the standard use in a physical library. Or maybe when the user clicks the borrow button, that goes to a list which the librarian has to confirm.