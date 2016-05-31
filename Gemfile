source 'https://rubygems.org'
ruby "2.2.3"

gem 'rails', '4.2.5'
gem 'bcrypt', '3.1.7'
gem 'will_paginate', '3.0.7'
gem 'bootstrap-will_paginate', '0.0.10'
gem 'bootstrap-sass', '3.2.0.0'
gem 'sass-rails', '5.0.2'
gem 'uglifier', '2.5.3'
gem 'coffee-rails', '4.1.0'
gem 'jquery-rails', '4.0.3'
gem 'turbolinks', '2.3.0'
gem 'jbuilder', '2.2.3'
gem 'pg', '0.18.2'
gem 'sdoc', '0.4.0', group: :doc
gem "passenger", '>= 5.0.25', require: "phusion_passenger/rack_handler"

group :development, :test do
  gem 'byebug', '3.4.0'
  gem 'web-console', '2.0.0.beta3'
  gem 'spring', '1.1.3'
  gem 'faker', '1.4.2'
end

group :staging, :production  do
  gem 'ey_config'
  gem 'rails_12factor', '0.0.2'
end