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
3. **Setup environment variables:**
   ```bash
   cp .env.example .env.development
   cp .env.example .env.test
   ```
   Then edit the `.env.development` and `.env.test` files with your actual values.
4. **Setup the database:**
   ```bash
   rails db:setup
   ```
5. **Start the server:**
   ```bash
   rails server
   ```
6. **Default admin login:**
   - Email: admin@example.com
   - Password: admin123

## Environment Variables

This project uses the `dotenv-rails` gem to manage environment variables. The following files are used:

- `.env.example` - Template file with example variables
- `.env.development` - Development environment variables
- `.env.test` - Test environment variables

### Required Environment Variables

- `DATABASE_URL` - PostgreSQL connection string
- `SECRET_KEY_BASE` - Rails secret key base
- `RAILS_MASTER_KEY` - Rails master key for credentials
- `DEVISE_SECRET_KEY` - Devise secret key for authentication

### Optional Environment Variables

- `AWS_ACCESS_KEY_ID` - AWS access key for S3 storage
- `AWS_SECRET_ACCESS_KEY` - AWS secret key for S3 storage
- `AWS_REGION` - AWS region (default: us-east-1)
- `AWS_BUCKET` - S3 bucket name
- `SMTP_HOST` - SMTP server host for email
- `SMTP_PORT` - SMTP server port
- `SMTP_USERNAME` - SMTP username
- `SMTP_PASSWORD` - SMTP password

### Getting Started

1. Copy the example file:
   ```bash
   cp .env.example .env.development
   cp .env.example .env.test
   ```

2. Generate a new secret key base:
   ```bash
   rails secret
   ```

3. Update the environment files with your actual values.

## Automatic Deploy to Heroku
This project uses GitHub Actions to automatically deploy to Heroku every time a commit is pushed to the `main` branch.

### Setup
1. Set the following secrets in your GitHub repository:
   - `HEROKU_API_KEY`: Your Heroku account API key
   - `HEROKU_APP_NAME`: Your Heroku app name
   - `HEROKU_EMAIL`: Your Heroku account email

### How it works
- On every push to `main`, the workflow in `.github/workflows/deploy-heroku.yml` will:
  - Check out the code
  - Set up Ruby, Node.js, and Yarn
  - Install dependencies
  - Deploy to Heroku

### Manual Deploy
To trigger a deploy manually (without pushing new code):
1. Go to the **Actions** tab in your GitHub repository.
2. Select the **Deploy to Heroku** workflow.
3. Click **Run workflow** and select the `main` branch.

## Tests
```bash
bundle exec rspec
```

---

## **1. Create an S3 Bucket on AWS**

1. Go to the [AWS S3 Console](https://s3.console.aws.amazon.com/s3/home).
2. Click **Create bucket**.
3. Enter a unique bucket name (e.g., `garage-sale-florenca-production`).
4. Choose a region (e.g., `us-east-1`).
5. Leave the rest as default or adjust as needed, then click **Create bucket**.

---

## **2. Create an IAM User for S3 Access**

1. Go to the [IAM Console](https://console.aws.amazon.com/iam/home).
2. Click **Users** > **Add users**.
3. Enter a username (e.g., `heroku-activestorage`).
4. Select **Access key - Programmatic access**.
5. Click **Next: Permissions**.
6. Click **Attach existing policies directly**.
7. Search for and select **AmazonS3FullAccess** (or create a custom policy for more restricted access).
8. Click **Next: Tags** > **Next: Review** > **Create user**.
9. **Save the Access Key ID and Secret Access Key**.

---

## **3. Add S3 Credentials to Heroku Config Vars**

In your project directory, run:

```bash
heroku config:set AWS_ACCESS_KEY_ID=your-access-key-id
heroku config:set AWS_SECRET_ACCESS_KEY=your-secret-access-key
heroku config:set AWS_REGION=your-bucket-region
heroku config:set AWS_BUCKET=your-bucket-name
```

Example:

```bash
heroku config:set AWS_ACCESS_KEY_ID=AKIA...
heroku config:set AWS_SECRET_ACCESS_KEY=abcd1234...
heroku config:set AWS_REGION=us-east-1
heroku config:set AWS_BUCKET=garage-sale-florenca-production
```

---

## **4. Update `config/storage.yml`**

Make sure you have an S3 service defined (Rails 8 default includes this):

```yaml
amazon:
  service: S3
  access_key_id: <%= ENV['AWS_ACCESS_KEY_ID'] %>
  secret_access_key: <%= ENV['AWS_SECRET_ACCESS_KEY'] %>
  region: <%= ENV['AWS_REGION'] %>
  bucket: <%= ENV['AWS_BUCKET'] %>
```

---

## **5. Set ActiveStorage to Use S3 in Production**

In `config/environments/production.rb`, set:

```ruby
config.active_storage.service = :amazon
```

---

## **6. Commit and Deploy**

```bash
git add config/storage.yml config/environments/production.rb
git commit -m "Configure ActiveStorage to use S3 in production"
git push origin main
```

Heroku will deploy and use S3 for all file uploads in production.

---

## **7. (Optional) Test Uploads**

- Upload an image in your production app and check your S3 bucket to confirm the file appears.

---

### **Summary**

- Create S3 bucket and IAM user
- Add AWS credentials to Heroku config
- Set up `storage.yml` and `production.rb`
- Deploy

If you want, I can check or update your `storage.yml` and `production.rb` for you—just ask!

## Image Processing Requirements

### Local Development (macOS/Homebrew)
To enable ActiveStorage image variants (thumbnails, resizing, etc.), you must install [libvips](https://libvips.github.io/libvips/):

```bash
brew install vips
```

### Heroku Deployment
- Heroku's default stack already includes `libvips` and all required image libraries for ActiveStorage.
- **No manual installation is needed** unless you use a custom Dockerfile (in which case, add `libvips` to your image).
