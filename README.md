# Referrer

[![Build Status](https://api.travis-ci.org/salkar/referrer.svg?branch=master)](http://travis-ci.org/salkar/referrer)
[![Code Climate](https://codeclimate.com/github/salkar/referrer.svg)](https://codeclimate.com/github/salkar/referrer)

## Installation

rake referrer:install:migrations
rake db:migrate
mount Referrer::Engine => '/referrer'

include Referrer::ControllerAdditions
current_user

//= require referrer/application

## Test
rake referrer:install:migrations
rails g referrer:tracking Request
rake db:drop
rake db:create
rake db:migrate
rake assets:precompile
RAILS_ENV=test rails s

sudo apt-get install xvfb

## License

This project rocks and uses MIT-LICENSE.