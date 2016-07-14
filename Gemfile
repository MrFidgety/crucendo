source 'https://rubygems.org'
ruby "2.3.0"

gem 'rails',                    '4.2.5'
gem 'bcrypt',                   '3.1.7'
gem 'will_paginate',            '3.0.7'
gem 'bootstrap-will_paginate',  '0.0.10'
gem 'bootstrap-sass',           '3.2.0.0'
gem 'sass-rails',               '5.0.2'
gem 'uglifier',                 '2.5.3'
gem 'coffee-rails',             '4.1.0'
gem 'jquery-rails',             '4.0.3'
gem 'jquery-ui-rails',          '5.0.5'
gem 'turbolinks',               '2.3.0'
gem 'jbuilder',                 '2.2.3'
gem 'pg',                       '0.18.2'
gem 'country_select',           '2.5.2'
gem 'font-awesome-sass',        '~> 4.6.2'
gem 'sdoc',                     '0.4.0', group: :doc
gem "passenger",                '>= 5.0.25', require: "phusion_passenger/rack_handler"
gem 'data-confirm-modal',       github: 'ifad/data-confirm-modal'
gem 'breadcrumbs_on_rails'
gem 'browser'

group :development, :test do
  gem 'byebug',                 '3.4.0'
  gem 'web-console',            '2.0.0.beta3'
  gem 'spring',                 '1.1.3'
  gem 'faker',                  '1.4.2'
end

group :test do
  gem 'minitest-reporters',     '1.0.5'
  gem 'mini_backtrace',         '0.1.3'
  gem 'guard-minitest',         '2.3.1'
end

group :staging, :production  do
  gem 'ey_config'
  gem 'envyable'
  gem 'rails_12factor',         '0.0.2'
end