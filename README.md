# Garage Sale Florença

A platform to display items for sale, like an online Garage Sale.

## Tech Stack
- Rails 8
- Ruby 3.4.4
- PostgreSQL 16
- ActiveStorage (images)
- ActionText (rich text)
- Devise (admin authentication)
- RSpec (testing)
- Kaminari (pagination)
- SimpleCSS (UI)

## Requirements
- [rbenv](https://github.com/rbenv/rbenv) for Ruby version management
- Ruby 3.4.4
- Node.js & Yarn
- PostgreSQL 16 (recommended)

## Install PostgreSQL (macOS/Homebrew)
```bash
brew install postgresql@16
brew services start postgresql@16
```

## Setup
1. **Install Ruby 3.4.4 using rbenv:**
   ```bash
   rbenv install 3.4.4
   rbenv local 3.4.4
   ```
2. **Install dependencies:**
   ```bash
   gem install bundler
   bundle install
   yarn install --check-files
   ```
3. **Setup the database:**
   ```bash
   rails db:setup
   ```
4. **Set WhatsApp number in environment:**
   ```bash
   export WHATSAPP_NUMBER='+5511999999999'
   ```
5. **Start the server:**
   ```bash
   rails server
   ```
6. **Default admin login:**
   - Email: admin@example.com
   - Password: admin123

## Tests
```bash
bundle exec rspec
```
