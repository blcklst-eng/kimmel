source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.3"

gem "aws-sdk-s3", require: false
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", ">= 1.1.0", require: false
gem "dotenv-rails"
gem "exponent-server-sdk"
gem "graphql", "~> 1.9.0"
gem "graphql-batch"
gem "http"
gem "image_processing", "~> 1.2"
gem "jwt"
gem "mime-types"
gem "paranoia", "~> 2.2"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 3.11"
gem "racecar"
gem "rack-cors"
gem "rails", "~> 6.0.0.rc1"
gem "redis", "~> 4.0"
gem "redis-namespace"
gem "searchkick"
gem "sentry-raven"
gem "sidekiq"
gem "skylight"
gem "statesman", "~> 3.5.0"
gem "twilio-ruby", "~> 5.9.0"
gem "whenever", require: false

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails", "~> 3.6"
  gem "standard"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "shoulda-matchers", "~> 4.0.1"
end

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
