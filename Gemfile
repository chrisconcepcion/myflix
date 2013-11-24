source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails', '4.0.0'
gem 'haml-rails'
gem 'bootstrap-sass', '~> 2.3.2.2'
gem 'draper' ,'~> 1.0'
gem 'bcrypt-ruby'
gem 'bootstrap_form'
gem "figaro"
gem 'sidekiq'
gem 'unicorn'
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'carrierwave'
gem "fog", "~> 1.3.1"



group :assets do
  gem 'sass-rails',   '~> 4.0.0'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'pry-nav'
  gem "letter_opener"
end

group :development, :test do
	gem "rspec-rails", "~> 2.14.0"
	gem "factory_girl_rails", "~> 4.2.1"
end

group :test do
	gem 'pry'
  gem 'pry-nav'
	gem "faker", "~> 1.1.2"
	gem "capybara", "~> 2.1.0"
	gem "database_cleaner", "~> 1.0.1"
	gem "launchy", "~> 2.3.0"
	gem "selenium-webdriver", "~> 2.35.1"
	gem "shoulda-matchers"
	gem 'fabrication'
	gem 'capybara-email'
end



group :production do
  gem 'pg'
end

gem 'jquery-rails'
