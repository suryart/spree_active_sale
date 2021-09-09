# Welcome to Spree Active Sale

Spree Active Sale makes it easy to handle flash sale/ daily deals behavior within a spree application. By this, you can have a product, or group number of products in a taxon, attach that product, or taxon to a sale event with a start and end date for scheduling. So that, your sale event will only be available between the dates given and when the sale is gone(i.e. not live), it will not be accessible at any point till you create a new one or reschedule the same.

> It's all about selling your first product. ~ [Vivek SP](https://twitter.com/viveksp)

----------

## FEATURES

* Provides a quick implementation of flash sales/ daily deals behavior by a easy scheduler a.k.a *ActiveSale*.
* Provides an admin interface for creating/ scheduling, managing, sorting, bundeling, or re-scheduling sale events.
* Provides a view helper for countdown timer to show sale's ending time, which will be shown to your customers. This eventually makes a sense of urgency on your customers' mind.
* Supplies methods for class <tt>Spree::ActiveSaleEvent</tt> like: <tt>live</tt>, <tt>active</tt>, <tt>live_active</tt>, <tt>hidden</tt>, <tt>live_active_and_hidden</tt>, <tt>upcoming_events</tt>, <tt>starting_today</tt>, <tt>ending_today</tt>.

## LINKS

* Demo application: [Spree Active Sale Demo](https://github.com/suryart/spree_active_sale_demo)
* Dependency status: [![Dependency Status](https://gemnasium.com/suryart/spree_active_sale.png)](https://gemnasium.com/suryart/spree_active_sale)
* Code Climate: [![Code Climate](https://codeclimate.com/github/suryart/spree_active_sale.png)](https://codeclimate.com/github/suryart/spree_active_sale)
* Build Status: [![Build Status](https://travis-ci.org/suryart/spree_active_sale.png?branch=2-0-stable)](https://travis-ci.org/suryart/spree_active_sale)
* Converage Status: [![Coverage Status](https://coveralls.io/repos/suryart/spree_active_sale/badge.png?branch=2-0-stable)](https://coveralls.io/r/suryart/spree_active_sale?branch=2-0-stable)
* Issues: [Project issues](https://github.com/suryart/spree_active_sale/issues)
* Fork: [Fork this Project](https://github.com/suryart/spree_active_sale/fork_select)

## INSTALLATION

### In a rails application with Spree installed include the following line in your Gemfile:
  * Get the latest greatest from github:

      ```ruby
        gem 'spree_active_sale' , :git => 'git://github.com/suryart/spree_active_sale.git'
      ```

  * Get the 2-0-stable branch for Spree 2.0.x from github:

      ```ruby
        gem 'spree_active_sale' , :git => 'git://github.com/suryart/spree_active_sale.git', :branch => '2-0-stable'
      ```

  * Or get it from rubygems.org by mentioning the following line in your Gemfile:

      ```ruby
        gem 'spree_active_sale', '2.0.0'
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

    # Output => => #<Spree::ActiveSale id: 1, name: "January 2013 sales",
    # created_at: "2013-04-16 07:26:45", updated_at: "2013-04-16 07:26:45">

    # Then create an Event under this sale by:
    event = active_sale.active_sale_events.create(:name => "January 2013 sales",
        :start_date => Time.now, :end_date => 1.day.from_now)

    # now add taxons for events, taxons acts as tags/ categories.
    event.taxons = [taxon]

    # Now try to access this sale event in web browser.
    # There should be no any other sale event link accessible except
    # If you access the taxon only this sale event will be shown and accessible.
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

    # to check if an active sale event is live?
    active_sale_event = Spree::ActiveSaleEvent.first
    # output => => #<Spree::ActiveSaleEvent id: 1, name: "Event 1", description: "20% Off",
    # permalink: "t/designers/event-1",
    # start_date: "2013-03-22 04:00:03", end_date: "2013-04-25 04:00:00", is_active: true,
    # is_hidden: false, is_permanent: false, active_sale_id: 31,
    # created_at: "2013-03-23 08:37:29", updated_at: "2013-04-09 18:55:37",
    # position: 0, discount: nil>

    # Now do:
    active_sale_event.live?
    # output => true

    # you can also check if that event was live on a particular datetime, for example:
    active_sale_event.live?(1.month.ago)

    # to check if an active sale event is live and active:
    active_sale_event.live_and_active?
    # output => true

    # you can check if that event was live and active on a particular datetime by:
    active_sale_event.live_and_active?(Time.zone.now - 1.month)

    # to check if an instance/ object is live or not?.
    # Here instance can be an object of
    # "Spree::ActiveSaleEvent", "Spree::Variant", "Spree::Product", or "Spree::Taxon" class.
    # Which simply says if sale event for that instance is accessible for users or not.
    Spree::ActiveSaleEvent.is_live?(instance)

    # You can list the rows where a column, for example- :start_date, is not blank,
    # and get it sorted using not_blank_and_sorted_by(:column_name) like this:
    Spree::SaleEvent.not_blank_and_sorted_by(:start_date)
    Spree::ActiveSale.not_blank_and_sorted_by(:start_date)
    Spree::ActiveSaleEvent.not_blank_and_sorted_by(:start_date)

    # Also, you can chain this method with other scopes, like this:
    Spree::ActiveSaleEvent.live_active.not_blank_and_sorted_by(:start_date)
  ```

## Overriding countdown timer's layout differently for different events
There is a view helper which shows the count down timer. This extension uses [jQuery Countdown](http://keith-wood.name/countdown.html) library for countdown timer. View helper available for count down timer is:

  ```ruby
    <%= sale_event_timer(active_sale_event) %>
  ```
You can pass a layout(layout is optional. default value is: '{dn} days {hnn}{sep}{mnn}{sep}{snn}' ) according to your requirement like this:

  ```ruby
    <%= sale_event_timer(active_sale_event, '{dn} days {hnn} hours {sep}{mnn} minutes {sep}{snn} seconds') %>
  ```

Please visit [jQuery Countdown](http://keith-wood.name/countdown.html) for more layouts.

## Overriding configuration and preferences

You can use this at the bottom of your **application's app/config/initializers/spree.rb** for configuration:

  ```ruby
    Spree::ActiveSale.config do |config|
      config.admin_active_sales_per_page = 20
      config.active_sales_per_page = 10
      config.admin_active_sale_events_per_page = 30
      config.active_sale_events_per_page = 40
    end
  ```
Since you can not set boolean values from the block config shown above for assignment(:?=). To override boolean preferences, you can always do this with in the spree config file spree.rb:

  ```ruby
    Spree::ActiveSaleConfig[:paginate_sale_events_for_admin?] = true
    Spree::ActiveSaleConfig[:paginate_sales_for_admin?] = true
    Spree::ActiveSaleConfig[:paginate_sale_events_for_user?] = true
    Spree::ActiveSaleConfig[:paginate_sales_for_user?] = false
    Spree::ActiveSaleConfig[:name_with_event_position?] = true
  ```

## Countdown Flash Sales Use Case

![Active Sale Event Form](https://user-images.githubusercontent.com/10734553/131882564-af095ee0-7827-4f5f-a492-062bc6e9bfbf.png)

Active sale event provide option start date to start the event for discount on item. We need to inform user before the event start by clicking active so it means that the event is active and ready to display to user and we can count down from that time to the start date to inform user about count down.

## TODOs

* Improve testing and write more test cases.

## Testing


Try this markdown:

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec


When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_active_sale/factories'
```

## Contributing

1. [Fork](https://help.github.com/articles/fork-a-repo) the project
2. Make one or more well commented and clean commits to the repository. You can make a new branch here if you are modifying more than one part or feature.
3. Add tests for it. This is important so I don’t break it in a future version unintentionally.
4. Perform a [pull request](https://help.github.com/articles/using-pull-requests) in github's web interface.

## NOTE

The current version supports Spree's versions: 1.3.x and 2.0.x. Older versions of Spree are unlikely to work, so attempt at your own risk.


## License
Copyright (c) 2013 Surya Tripathi, released under the New BSD License
