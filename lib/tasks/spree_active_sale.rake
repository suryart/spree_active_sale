namespace :spree_active_sale do
  desc "Copies all migrations and assets"
  task :install do
    Rake::Task['spree_active_sale:install:migrations'].invoke
    Rake::Task['spree_active_sale:install:assets'].invoke
  end

  namespace :install do
    desc "Copies all assets to the application"
    task :assets do
      source = File.join(File.dirname(__FILE__), '..', '..', 'app', 'assets')
      destination = File.join(Rails.root, 'app', 'assets')
      puts "INFO: Mirroring assets from #{source} to #{destination}"
      `rails generate spree_active_sale:assets`
    end
  end
end
