# Referrer

[![Build Status](https://api.travis-ci.org/salkar/referrer.svg?branch=master)](http://travis-ci.org/salkar/referrer)
[![Code Climate](https://codeclimate.com/github/salkar/referrer.svg)](https://codeclimate.com/github/salkar/referrer)

Referrer tracks sources with which users visit your site, computes priority of these sources and provides linking for sources with tracked model's records.

Sample questions which Referrer can help to answer:

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

Add to your models which objects may be returned from `current_user` (or your same method, specified in `Referrer.current_user_method_name`) `include Referrer::OwnerModelAdditions`. For sample if your `current_user` return `User` objects:

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

## Settings

Referrer settings can be changed in initializers. For sample, you can create `config/initializers/referrer.rb` and add your custom settings to it.

###Settings list

1. **current_user_method_name** - method name in ApplicationController which return current logged in object.
    ```ruby
      :current_user
    ```

2. **js_settings** - options passes to js part of Referrer.
    ```ruby
      {}
    ```
    Available options:
    * cookies
    
        ```javascript
            {prefix: 'referrer',
             domain: null,
             path: '/'}
        ```
        
    * object
    
        ```javascript
            {name: 'referrer'}
        ```
        
    * callback
    
        ```javascript
            null
        ```
    
3. **js_csrf_token** - js code to get CSRF token if it is used.
    ```ruby
      <<-JS
        var tokenContainer = document.querySelector("meta[name=csrf-token]");
        return tokenContainer ? tokenContainer.content : null;
      JS
    ```
    
4. **markup_generator_settings** - options for Referrer::MarkupGenerator. 
   ```ruby
     {}
   ```
  Available options:
  * organics
  
      ```ruby
        [{host: 'search.daum.net', param: 'q'},
        {host: 'search.naver.com', param: 'query'},
        {host: 'search.yahoo.com', param: 'p'},
        {host: /^(www\.)?google\.[a-z]+$/, param: 'q', display: 'google'},
        {host: 'www.bing.com', param: 'q'},
        {host: 'search.aol.com', params: 'q'},
        {host: 'search.lycos.com', param: 'q'},
        {host: 'edition.cnn.com', param: 'text'},
        {host: 'index.about.com', param: 'q'},
        {host: 'mamma.com', param: 'q'},
        {host: 'ricerca.virgilio.it', param: 'qs'},
        {host: 'www.baidu.com', param: 'wd'},
        {host: /^(www\.)?yandex\.[a-z]+$/, param: 'text', display: 'yandex'},
        {host: 'search.seznam.cz', param: 'oq'},
        {host: 'www.search.com', param: 'q'},
        {host: 'search.yam.com', param: 'k'},
        {host: 'www.kvasir.no', param: 'q'},
        {host: 'buscador.terra.com', param: 'query'},
        {host: 'nova.rambler.ru', param: 'query'},
        {host: 'go.mail.ru', param: 'q'},
        {host: 'www.ask.com', param: 'q'},
        {host: 'searches.globososo.com', param: 'q'},
        {host: 'search.tut.by', param: 'query'}]
      ```
  * referrals
  
      ```ruby
        [{host: /^(www\.)?t\.co$/, display: 'twitter.com'}, 
        {host: /^(www\.)?plus\.url\.google\.com$/, display: 'plus.google.com'}]
      ```
  * utm_synonyms
  
      ```ruby
        {'utm_source'=>[], 'utm_medium'=>[], 'utm_campaign'=>[], 'utm_content'=>[], 'utm_term'=>[]}
      ```
  * array_params_joiner
      
      ```ruby
        ', '
      ```
      
5. **session_duration** - after this duration left, new session will be created and its sources priorities will be computed without regard to past sessions sources.
    ```ruby
        3.months
    ```
    
6. **sources_overwriting_schema** - source's kind priorities for priority source computation.
    ```ruby
        {direct: %w(direct),
         referral: %w(direct referral organic utm),
         organic: %w(direct referral organic utm),
         utm: %w(direct referral organic utm)}
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
