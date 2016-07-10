# Referrer

## Installation

rake referrer:install:migrations
rake db:migrate
mount Referrer::Engine => '/referrer'

include Referrer::ControllerAdditions
current_user

//= require referrer/application

## License

This project rocks and uses MIT-LICENSE.