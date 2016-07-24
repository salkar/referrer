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
end
