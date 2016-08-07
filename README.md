# Referrer

[![Build Status](https://api.travis-ci.org/salkar/referrer.svg?branch=master)](http://travis-ci.org/salkar/referrer)
[![Code Climate](https://codeclimate.com/github/salkar/referrer.svg)](https://codeclimate.com/github/salkar/referrer)

Referrer tracks sources with witch users visit your site, computes priority of these sources and provides linking for sources with tracked model's records.

Sample questions whitch Referrer can help to answer:

- Where did this user come from?
- `{utm_source: 'google', utm_medium: 'organic', utm_campaign: '(none)', utm_content: '(none)', utm_term: 'user search query', kind: 'organic'}`
<br /><br />
- Where did new users come from last month?
- `[{utm_source: 'google', utm_medium: 'organic', utm_campaign: '(none)', utm_content: '(none)', utm_term: 'user search query', kind: 'organic', count: 1}, {utm_source: 'google', utm_campaign: 'adv_campaign', utm_medium: 'cpc', utm_content: 'adv 1', utm_term: 'some text', kind: 'utm', count: 2}, etc...]`
<br /><br />
- Where did user who make purchase come from?
- `{utm_source: 'twitter.com', utm_medium: 'referral', utm_campaign: '(none)',  utm_content: '/some_path', utm_term: '(none)', kind: 'referral'}`
<br /><br />
- Where did users who left some requests come from last week?
- `[{utm_source: '(direct)', utm_medium: '(none)', utm_campaign: '(none)', utm_content: '(none)', utm_term: '(none)', kind: 'direct', count: 3}, {utm_source: 'google', utm_campaign: 'adv_campaign', utm_medium: 'cpc', utm_content: 'adv 2', utm_term: 'another text', kind: 'utm', count: 5}, etc...]`

## Installation

### Basic setup

1. Add Referrer to your Gemfile:
    ```ruby
      gem 'referrer'
    ```

2. Run the bundle command to install it:
    ```bash
      bundle install
    ```

3. Copy migrations from engine:
    ```bash
      rake referrer:install:migrations
    ```

4. Migrate your database:
    ```bash
      rake db:migrate
    ```

5. Mount engine's routes at `config/routes.rb`
    ```ruby
      mount Referrer::Engine => '/referrer'
    ```
    
6. Require engine's js in your `application.js` file:
    ```ruby
      //= require referrer/application
    ```

7. Add to your ApplicationController:
    ```ruby
      include Referrer::ControllerAdditions
    ```
    
8. If your `current_user` method has another name, add to `config/initializers/referrer.rb`:
    ```ruby
      Referrer.current_user_method_name = :your_method_name
    ```

### Setup your statistics owners

Add to your models whitch objects may be returned from `current_user` (or your same method, specified in `Referrer.current_user_method_name`) `include Referrer::OwnerModelAdditions`. For sample if your `current_user` return `User` objects:

  ```ruby
    class User < ActiveRecord::Base
      include Referrer::OwnerModelAdditions
      #...
    end
  ```

### Setup your tracked models

1. Add to models you want to track `include Referrer::TrackedModelAdditions`. For sample if you want to track where users who make orders come from (`Order` class):
    ```ruby
      class Order < ActiveRecord::Base
        include Referrer::TrackedModelAdditions
        #...
      end
    ```
    
2. After you create tracked model record next time you can link record with current source. For sample (with `Order` object):
    ```ruby
      # OrdersControllers#create
      #...
      if @order.save
        @order.referrer_link_with(referrer_user) # referrer_user defined in Referrer::TrackedModelAdditions
      else
      #...
    ```




## Test
rake referrer:install:migrations
rake db:drop
rake db:create
rake db:migrate
rake assets:precompile
RAILS_ENV=test rails s

sudo apt-get install xvfb

## License

This project rocks and uses MIT-LICENSE.
