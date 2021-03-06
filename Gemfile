source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use postgres as database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'simple_form'
gem 'validates_timeliness', '~> 4.0'
gem 'materialize-sass'
# for pagination
gem 'kaminari'
# for user authorization
gem 'cancan'
# use ActiveModel has_secure_password 
gem 'bcrypt-ruby'

# for postgres and Heroku
gem 'pg_array_parser'
gem 'postgres_ext'

source 'https://rails-assets.org' do
  gem 'rails-assets-materialize'
end
gem 'filterrific'
gem 'font-awesome-rails'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # faker for populate script
  gem 'faker'
  gem 'populator3'
  # ERD generator
  gem 'rails-erd'
end

# Gems used only in testing
group :test do
  gem 'shoulda'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'capybara'
  gem 'simplecov'
end

# For Heroku integration
gem 'rails_12factor', group: :production
ruby "2.2.0"
