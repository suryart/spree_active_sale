# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_active_sale/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_active_sale'
  s.version     = SpreeActiveSale.version
  s.summary     = 'Spree Active Sale to handle flash sales/ daily deals behavior for spree.'
  s.description = 'Spree Active Sale makes it easy to handle flash sale/ daily deals behavior with in a spree application. By this, you can have a variant, product, or group number of products in a taxon, attach that variant, product, or taxon to a sale event with a start and end date for scheduling. So that, your sale event will only be available between the dates given and when the sale is gone(i.e. not live), it will not be accessible at any point till you create a new one or re-schedule the same.'
  s.required_ruby_version = '>= 2.5.0'


  s.author    = 'Surya Tripathi'
  s.email     = 'raj.surya19@gmail.com'
  s.homepage  = 'https://github.com/suryart/spree_active_sale'

  # s.files        = Dir['LICENSE', 'README.md', 'app/**/*', 'config/**/*', 'lib/**/*', 'db/**/*']
  # #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  # s.require_path = 'lib'
  # s.requirements << 'none'


  s.files       = `git ls-files`.split("\n").reject { |f| f.match(/^spec/) && !f.match(/^spec\/fixtures/) }
  s.require_path = 'lib'
  s.requirements << 'none'

  # s.add_dependency 'spree_core', '~> 2.0.0'

  # s.add_development_dependency 'capybara', '~> 2.1.0'
  # s.add_development_dependency 'coffee-rails'
  # s.add_development_dependency 'database_cleaner'
  # s.add_development_dependency 'factory_girl_rails', '~> 4.2.0'
  # s.add_development_dependency 'ffaker'
  # s.add_development_dependency 'rspec-rails',  '~> 2.9'
  # s.add_development_dependency 'guard-rspec',  '3.0.2'
  # s.add_development_dependency 'sass-rails'
  # s.add_development_dependency 'sqlite3'

  spree_version = '>= 4.2.0', '< 6.0'
  s.add_dependency 'spree_core', spree_version
  s.add_dependency 'spree_api', spree_version
  s.add_dependency 'spree_backend', spree_version
  s.add_dependency 'spree_extension'
  s.add_dependency 'spree_analytics_trackers'

  # gem 'factory_bot_rails'
  # gem 'ffaker'

  # %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
  #   gem lib, git: "https://github.com/rspec/#{lib}.git", branch: 'master' # Previously '4-0-dev' or '4-0-maintenance' branch
  # end

  s.add_development_dependency 'spree_dev_tools'
end
