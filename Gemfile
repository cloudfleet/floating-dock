source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
gem 'rack-cors', :require => 'rack/cors'
gem 'rails-api'
gem 'activesupport-json_encoder'
# Model serialization
gem 'active_model_serializers'
gem 'delayed_job_active_record'
gem 'net-ssh'
gem 'rye'


gem 'devise_token_auth'
gem 'cancancan', '~> 1.10'
gem 'omniauth'
gem 'json-jwt'
gem 'jwt'
gem 'base32', '~> 0.3.0'
gem 'pg'
gem 'pg_search'

gem 'rubygems-update', require: 'rubygems/package'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

group :production do
  gem 'sendgrid'
  gem 'rails_12factor'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
