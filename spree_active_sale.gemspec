# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_active_sale'
  s.version     = '1.0.5'
  s.summary     = 'Spree Active Sale to handle flash sales/ daily deals behavior for spree.'
  s.description = 'Spree Active Sale makes it easy to handle flash sale/ daily deals behavior with in a spree application. By this, you can group products in a taxon, attach that taxon to a sale event with a start and end date for scheduling. So that, your sale event will only be available between the dates given and when the sale is gone(i.e. not live), it will not be accessible at any point till you create a new one or re-schedule the same.'
  s.required_ruby_version = '>= 1.9.3'

  s.author    = 'Surya Tripathi'
  s.email     = 'raj.surya19@gmail.com'
  # s.homepage  = 'http://www.spreecommerce.com'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 1.3.0'

  s.add_development_dependency 'capybara', '~> 2.0.2'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'factory_girl', '~> 4.2.0'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.9'
  s.add_development_dependency 'guard-rspec',  '~> 2.3'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'sqlite3'
end
