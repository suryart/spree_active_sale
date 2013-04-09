# Welcome to Spree Active Sale

Spree Active Sale makes it easy to handle flash sale/ daily deals behavior within a spree application. By this, you can have a product, or group number of products in a taxon, attach that product, or taxon to a sale event with a start and end date for scheduling. So that, your sale event will only be available between the dates given and when the sale is gone(i.e. not live), it will not be accessible at any point till you create a new one or reschedule the same.

> It's all about selling your first product. ~ [Vivek SP](https://twitter.com/viveksp)

----------

## FEATURES

* Provides a quick implementation of flash sales/ daily deals behavior by a easy scheduler a.k.a *ActiveSale*.
* Provides an admin interface for creating/ scheduling, managing, or re-scheduling sale events.
* Provides a view helper for countdown timer to show sale's ending time, which will be shown to your customers. This eventually makes a sense of urgency in your customers' mind.
* Supplies methods for class <tt>Spree::ActiveSaleEvent</tt> like: <tt>live</tt>, <tt>active</tt>, <tt>live_active</tt>, <tt>hidden</tt>, <tt>live_active_and_hidden</tt>, <tt>upcoming_events</tt>, <tt>starting_today</tt>, <tt>ending_today</tt>.

## LINKS

* Demo application: [Spree Active Sale Demo](https://github.com/suryart/spree_active_sale_demo)
* Dependency status: [![Dependency Status](https://gemnasium.com/suryart/spree_active_sale.png)](https://gemnasium.com/suryart/spree_active_sale)
* Code climate: [![Code Climate](https://codeclimate.com/github/suryart/spree_active_sale.png)](https://codeclimate.com/github/suryart/spree_active_sale)
* Build Status: [![Build Status](https://travis-ci.org/suryart/spree_active_sale.png)](https://travis-ci.org/suryart/spree_active_sale)
* Issues: [Project issues](https://github.com/suryart/spree_active_sale/issues)
* Fork: [Fork this Project](https://github.com/suryart/spree_active_sale/fork_select)

## INSTALLATION

### In a rails application with Spree installed include the following line in your Gemfile:
  * Get the latest greatest from github: 
    
      ```ruby
        gem 'spree_active_sale' , :git => 'git://github.com/suryart/spree_active_sale.git'
      ```

  * Get the 1-3-stable branch for Spree 1.3.x from github: 
    
      ```ruby
        gem 'spree_active_sale' , :git => 'git://github.com/suryart/spree_active_sale.git', :branch => '1-3-stable'
      ```

  * Or get it from rubygems.org by mentioning the following line in your Gemfile:
    
      ```ruby 
        gem 'spree_active_sale', '1.0.6'
      ```

### Then run the following commands: 

    $ bundle install
    $ rails g spree_active_sale:install 
    $ rake db:migrate
    $ rails s 

### Optional commands available: 

    $ rails g spree_active_sale:assets          ; to copy assets from plugin dir to app's dir
    $ rake spree_active_sale:install            ; Copies all migrations and assets to the application
    $ rake spree_active_sale:install:assets     ; Copies all assets to the application
    $ rake spree_active_sale:install:migrations ; Copies all migrations to the application
    $ rake db:migrate                           ; do not forget to run this after copying migrations

### Including stylesheet and javascript for admin and store
If you do not run **rails g spree_active_sale:install** then you must have to add stylesheets and javascripts accordinlgy. As these steps are important because, if you don't follow/ add them. You will not see datetime picker for start and end date in Admin area and countdown timer on the Store page.

##### Stylesheet usage in Rails >= 3.1(Only supported versions for now)

You will have to add stylesheet in the bottom of your **admin/all.css** file as follows -
  
    *= require admin/spree_active_sale

Later you will have to add stylesheet in the bottom of your **store/all.css** file as follows -
  
    *= require store/spree_active_sale

##### Javascript usage in Rails >= 3.1(Only supported versions for now)

You will have to add javascript in the bottom of your **admin/all.js** file as follows -
    
    //= require admin/spree_active_sale

You will have to add javascript in the bottom of your **store/all.js** file as follows -
    
    //= require store/spree_active_sale

## Example and usages

* For trying to see how this plugin works. You can create an *ActiveSale* and its events by following these commands in your <tt>rails console</tt>: 
  ```ruby
    # Get a taxon in rails console:
    taxon = Spree::Taxon.last

    # Create an ActiveSale
    active_sale = Spree::ActiveSale.create(:name => "January 2013 sales")

    # Output => #<Spree::ActiveSale id: 1, name: "January 2013 sales", 
    # created_at: "2013-01-20 20:33:57", updated_at: "2013-01-20 20:33:57">

    # Then create an Event under this sale by:
    event = taxon.active_sale_events.create(:name => "January 2013 sales", 
        :active_sale_id => active_sale.id, :start_date => Time.now, 
        :end_date => Time.now+1.day, :permalink => taxon.permalink)

    # Now try to access this taxon in web browser.
    # There should be no any other taxon/ product link accessible except 
    # the one we've created just now.
  ```
* When you have enough sale events in your database, you can try these commands as per your requirements :
  ```ruby
    # listing all sale events which are currently and suppose to be running.
    Spree::ActiveSaleEvent.live

    # listing all sale events which are active, they may or may not be live. 
    Spree::ActiveSaleEvent.active

    # to list all inactive sale events.
    Spree::ActiveSaleEvent.active(false) 

    # listing all sale events which are live and active, which includes hidden sales, too.
    Spree::ActiveSaleEvent.live_active 

    # to list all sale events which live and not active.
    Spree::ActiveSaleEvent.live_active(false)

    # listing all sale events which are hidden, they may or may not be live.
    Spree::ActiveSaleEvent.hidden

    # to list sale events which are not hidden.
    Spree::ActiveSaleEvent.hidden(false)

    # listing all sale events which are live, active, and hidden.
    Spree::ActiveSaleEvent.live_active_and_hidden

    # to list inactive and not hidden sale events, you can change values accordingly.
    Spree::ActiveSaleEvent.live_active_and_hidden(:active => false, :hidden => false)

    # listing all scheduled sale events which are going to be live in future.
    Spree::ActiveSaleEvent.upcoming_events
    
    # listing all past sale events which ended and not accessible to users.
    Spree::ActiveSaleEvent.past_events

    # listing all sale events which are going to or have start today.
    Spree::ActiveSaleEvent.starting_today

    # listing all sale events which are going to expire today.
    Spree::ActiveSaleEvent.ending_today

    # to check if an instance is live or not?. 
    # Here instance can be an object of 
    # "Spree::ActiveSaleEvent", "Spree::Variant", "Spree::Product", or "Spree::Taxon" class.
    # Which simply says if sale event for that instance is accessible for users or not.
    Spree::ActiveSaleEvent.is_live?(instance)
  ```


## TODOs

* Improve testing and write more test cases.
* Enhance the admin interface for active sales and events[U.I. and U.X.].
* Make time countdown helper flexible so that developers can modify according to their requirements.

## Testing

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec

## Contributing

1. [Fork](https://help.github.com/articles/fork-a-repo) the project
2. Make one or more well commented and clean commits to the repository. You can make a new branch here if you are modifying more than one part or feature.
3. Add tests for it. This is important so I don’t break it in a future version unintentionally.
4. Perform a [pull request](https://help.github.com/articles/using-pull-requests) in github's web interface.

## NOTE

The current version supports Spree 1.3.0 or above. Older versions of Spree are unlikely to work, so attempt at your own risk.


## License
Copyright (c) 2013 Surya Tripathi, released under the New BSD License
