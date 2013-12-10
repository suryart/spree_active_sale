# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_active_sale'
  s.version     = '1.3.3'
  s.summary     = 'Spree Active Sale to handle flash sales/ daily deals behavior for spree.'
  s.description = 'Spree Active Sale enables flash sale/ daily deals behavior within a spree application. Using this extension, you can have a single product, or number of products within a sale event with start and end date for scheduling. So, your sale event will only be available between the dates given and when the sale is expired(i.e. not live/ available), it will not be accessible at any point till you create a new sale event or reschedule the same.'
  s.required_ruby_version = '>= 1.9.2'

  s.author    = 'Surya Tripathi'
  s.email     = 'raj.surya19@gmail.com'
  s.homepage  = 'https://github.com/suryart/spree_active_sale'

  s.files        = Dir['LICENSE', 'README.md', 'app/**/*', 'config/**/*', 'lib/**/*', 'db/**/*']
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 1.3.2'

  s.add_development_dependency 'capybara', '~> 2.0.2'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl_rails', '~> 4.2.0'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.9'
  s.add_development_dependency 'guard-rspec',  '3.0.2'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'sqlite3'
end