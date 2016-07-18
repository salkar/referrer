$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'referrer/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'referrer'
  s.version     = Referrer::VERSION
  s.authors     = ['Sergey Sokolov']
  s.email       = ['sokolov.sergey.a@gmail.com']
  s.homepage    = 'https://github.com/salkar/referrer'
  s.summary     = 'TODO: Summary of Referrer.'
  s.description = 'TODO: Description of Referrer.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency('rails', '>= 4')

  s.add_development_dependency('pg')
  s.add_development_dependency('rspec-rails', '~> 3.4')
  s.add_development_dependency('database_cleaner')
  s.add_development_dependency('byebug')
  s.add_development_dependency('uglifier')
  s.add_development_dependency('watir-webdriver')
  s.add_development_dependency('headless')
end
