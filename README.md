# Referrer

## Installation

rake referrer:install:migrations
rake db:migrate
mount Referrer::Engine => '/referrer'

include Referrer::ControllerAdditions
current_user

//= require referrer/application

## Test
RAILS_ENV=production rake referrer:install:migrations
RAILS_ENV=production rake db:drop
RAILS_ENV=production rake db:create
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake assets:precompile
SECRET_KEY_BASE=test RAILS_SERVE_STATIC_FILES=true RAILS_ENV=production rails s

## License

This project rocks and uses MIT-LICENSE.