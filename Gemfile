source 'http://rubygems.org'

# Provides basic authentication functionality for testing parts of your engine
# gem 'spree_auth_devise', :git => "git://github.com/spree/spree_auth_devise", :branch => '2-0-stable'
# gem 'spree', :git => "git://github.com/spree/spree", :branch => '2-0-stable'
# gem 'coveralls', require: false

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'spree', github: 'spree/spree', branch: '4-2-stable'
gem 'spree_auth_devise', '~> 4.3'
gem 'coveralls', require: false
gem 'spree_analytics_trackers'

gem 'rails-controller-testing'
gem 'factory_bot'
gem 'ffaker'

gemspec
