source "https://rubygems.org"

ruby "3.2.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.5", ">= 7.1.5.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"
group :development do
  gem "web-console"
end

group :development, :test do
  gem "capybara"
  gem "selenium-webdriver"

  # Capistrano関連（重複しないようにまとめる）
  gem 'capistrano', '~> 3.17'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'
  gem 'capistrano3-unicorn'
  gem "factory_bot_rails"
  gem "faker"
end

group :production do
  gem 'unicorn', '6.1.0'
  # Capistranoは本来productionで不要ですが、もし必要なら以下を残す
  # gem 'capistrano', '~> 3.17'
  # gem 'capistrano-rails'
  # gem 'capistrano-bundler'
  # gem 'capistrano-rbenv'
  # gem 'capistrano3-unicorn'
end

# Devise導入
gem 'devise'

# 管理画面
gem 'activeadmin'

# UI構築サポート（任意）
# gem 'tailwindcss-rails'
gem 'chartkick' # 統計グラフ
gem 'groupdate' # 集計用
gem 'image_processing'      # ActiveStorage画像処理
gem "sassc" # SCSSコンパイラ
gem 'sassc-rails' # SCSSをRailsで使うためのgem
gem 'holidays' # 日本の祝日を扱うためのgem
gem "rspec-rails", "~> 7.1"

gem "rails-i18n", "~> 7.0"
