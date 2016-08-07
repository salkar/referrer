$:.push File.expand_path('../lib', __FILE__)

require 'referrer/version'

Gem::Specification.new do |s|
  s.name        = 'referrer'
  s.version     = Referrer::VERSION
  s.authors     = ['Sergey Sokolov']
  s.email       = ['sokolov.sergey.a@gmail.com']
  s.homepage    = 'https://github.com/salkar/referrer'
  s.summary     = "Referrer tracks sources with which users visit your site, computes priority of these sources and provides linking for sources with tracked model's records."
  s.description = "Tracking system for sources of site's visitors with sources priorities and linking most priority source with tracked orders/requests/etc"
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency('rails', '>= 4')
end
