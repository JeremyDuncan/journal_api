
# Journal API Documentation

## Overview
This project is a backend API for a journal application built using Ruby on Rails. The API provides endpoints for user authentication, managing posts, tags, and tag types. The API is designed to handle JSON requests and responses.
The application is built with scalability in mind, using Rails' best practices to ensure maintainability and ease of use.

## Table of Contents
- [Technologies Used](#technologies-used)
- [Setup Instructions](#setup-instructions)
    - [Clone the Repository](#clone-the-repository)
    - [Install Dependencies](#install-dependencies)
    - [Set Up Database](#set-up-database)
    - [Run Migrations](#run-migrations)
    - [Start the Server](#start-the-server)
- [API Endpoints](#api-endpoints)
    - [User Authentication](#user-authentication)
    - [Posts](#posts)
    - [Tags and Tag Types](#tags-and-tag-types)
- [Database Schema](#database-schema)
- [Gemfile Overview](#gemfile-overview)
- [Testing](#testing)
- [Deployment](#deployment)

## Technologies Used
- **Ruby**: 3.3.3
- **Rails**: 7.1.3
- **PostgreSQL**: Used as the primary database
- **Devise**: User authentication
- **WillPaginate**: Pagination for API responses
- **Rack CORS**: Handling Cross-Origin Resource Sharing (CORS)
- **Faker**: Generating fake data for testing and development
- **Puma**: Web server

## Setup Instructions

### Clone the Repository
First, clone the repository to your local machine:
```bash
git clone https://github.com/JeremyDuncan/journal-api.git
cd journal-api
```

### Install Dependencies
Install the necessary gems using Bundler:
```bash
bundle install
```

### Set Up Database
Configure your database credentials in `config/database.yml`:
```yaml
default: &default
adapter: postgresql
encoding: unicode
pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
username: <%= Rails.application.credentials.dig(:database, :username) %>
password: <%= Rails.application.credentials.dig(:database, :password) %>
host: localhost

development:
<<: *default
database: blog_api_development

test:
<<: *default
database: blog_api_test

production:
<<: *default
database: blog_api_production
```

### Run Migrations
Create and migrate the database:
```bash
rails db:create
rails db:migrate
```

### Start the Server
Start the Rails server:
```bash
rails server
```
The API will be accessible at `http://localhost:3000`.

## API Endpoints

### User Authentication
User authentication is managed using Devise, with custom controllers for JSON responses.

- **Sign Up**
    - `POST /users`: Register a new user (Only one user is allowed)

- **Sign In**
    - `POST /users/sign_in`: Authenticate a user and obtain a session token

- **Check User Exists**
    - `GET /users/exists`: Check if a user already exists in the system

### Posts
Posts are the primary content in the journal application. They can be created, read, updated, and deleted.

- **List Posts**
    - `GET /posts`: Retrieve a paginated list of posts, with optional filtering by year and month.

- **Show Post**
    - `GET /posts/:id`: Retrieve a single post by its ID.

- **Create Post**
    - `POST /posts`: Create a new post with optional tags. The `created_at` date can be specified.

- **Update Post**
    - `PUT /posts/:id`: Update an existing post and its associated tags.

- **Delete Post**
    - `DELETE /posts/:id`: Delete a post and its associated tags.

- **Search Posts**
    - `GET /posts/search`: Search posts by title, content, tags, or tag types.

### Tags and Tag Types
Tags and Tag Types are used to categorize and filter posts.

- **List Tags**
    - `GET /tags`: Retrieve a list of all tags, sorted by their associated tag types.

- **Create Tag**
    - `POST /tags`: Create a new tag, with an optional tag type.

- **Delete Tag**
    - `DELETE /tags/:id`: Delete a tag by its ID.

- **List Tag Types**
    - `GET /tags/tag_types`: Retrieve a list of all tag types.

- **Create Tag Type**
    - `POST /tags/tag_types`: Create a new tag type with a specified color.

- **Update Tag Type**
    - `PUT /tags/tag_types/:id`: Update the name or color of an existing tag type.

- **Delete Tag Type**
    - `DELETE /tags/tag_types/:id`: Delete a tag type by its ID.

## Database Schema
The application uses PostgreSQL as its database. The following is a summary of the main tables:

- **Users**
    - Handles authentication with Devise.
    - Ensures only one user can be created.

- **Posts**
    - Contains the main content of the journal, including a title and content.

- **Tags**
    - Used to categorize posts.
    - Linked to a `TagType`.

- **TagTypes**
    - Used to group tags under a specific category, each with a unique color.

- **PostTags**
    - A join table linking posts and tags.

## Gemfile Overview
The `Gemfile` includes all the dependencies required for the project:

- **Rails**: The main framework for the application.
- **PostgreSQL**: Database adapter.
- **Puma**: Web server.
- **Importmap-Rails**: Manages JavaScript dependencies.
- **Turbo-Rails** and **Stimulus-Rails**: For Hotwire support.
- **Jbuilder**: For building JSON responses.
- **Devise**: For user authentication.
- **WillPaginate**: For paginating API responses.
- **Rack CORS**: To handle cross-origin requests.

## Testing
To run the test suite, use the following command:

```bash
rails test
```

### Testing Libraries
- **Capybara**: For system tests.
- **Selenium-WebDriver**: For driving browser tests.

## Deployment
To deploy the application to a production environment:

1. Set up the database in the production environment.
2. Ensure the environment variables for the database credentials and API key are set.
3. Run migrations using:
   ```bash
   rails db:migrate RAILS_ENV=production
   ```
4. Start the server using:
   ```bash
   rails server -e production
   ```