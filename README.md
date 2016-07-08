# Referrer

## Installation

rake referrer:install:migrations
rake db:migrate
mount Referrer::Engine => '/referrer'

include Referrer::ControllerAdditions
current_user

## License

This project rocks and uses MIT-LICENSE.