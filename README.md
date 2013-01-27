Welcome to Spree Active Sale
============================

Spree Active Sale makes it easy to handle flash sale/ daily deals behavior with in a spree application. By this, you can have a variant, product, or group number of products in a taxon, attach that variant, product, or taxon to a sale event with a start and end date for scheduling. So that, your sale event will only be available between the dates given and when the sale is gone(i.e. not live), it will not be accessible at any point till you create a new one or re-schedule the same.


FEATURES
========

* Provides a quick implementation of flash sales/ daily deals behavior by a easy scheduler a.k.a *ActiveSale*.
* Provides an admin interface for creating/ scheduling, managing, or re-scheduling sales adn events.
* Supplies methods for class <tt>Spree::ActiveSale::Event</tt> like: <tt>live</tt>, <tt>active</tt>, <tt>live_active</tt>, <tt>hidden</tt>, <tt>live_active_and_hidden</tt>, <tt>upcoming_events</tt>, <tt>starting_today</tt>, <tt>ending_today</tt>.
* <tt>Spree::ActiveSale::Event.live</tt> lists all sale events which are currently and suppose to be running.
* <tt>Spree::ActiveSale::Event.active</tt> lists all sale events which are active, they may or may not be live. You can do <tt>Spree::ActiveSale::Event.active(false)</tt> to list all inactive sale events.
* <tt>Spree::ActiveSale::Event.live_active</tt> lists all sale events which are live and active, which includes hidden sales, too. Doing <tt>Spree::ActiveSale::Event.live_active(false)</tt> will list all sale events which live and not active.
* <tt>Spree::ActiveSale::Event.hidden</tt> lists all sale events which are hidden, they may or may not be live. You can do <tt>Spree::ActiveSale::Event.hidden(false)</tt> to list sale events which are not hidden.
* <tt>Spree::ActiveSale::Event.live_active_and_hidden</tt> lists all sale events which are live, active, and hidden. <tt>Spree::ActiveSale::Event.live_active_and_hidden(:active => false, :hidden => false)</tt> will list inactive and not hidden sale events, you can change values accordingly.
* <tt>Spree::ActiveSale::Event.upcoming_events</tt> lists all scheduled sale events which are going to be live in future.
* <tt>Spree::ActiveSale::Event.starting_today</tt> lists all sale events which are going to or have start today.
* <tt>Spree::ActiveSale::Event.ending_today</tt> lists all sale events which are going to expire today.
* <tt>Spree::ActiveSale::Event.is_live?(instance)</tt> here instance can be an object of "Spree::ActiveSale::Event", "Spree::Variant", "Spree::Product", or "Spree::Taxon" class, which simply says if sale event for that instance is accessible for users or not.


[![Dependency Status](https://gemnasium.com/suryart/spree_active_sale.png)](https://gemnasium.com/suryart/spree_active_sale)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/suryart/spree_active_sale)
[![Build Status](https://travis-ci.org/suryart/spree_active_sale.png?branch=master)](https://travis-ci.org/suryart/spree_active_sale)

INSTALLATION
============

In a rails application with Spree installed include the following line in your Gemfile:
  * To use the master branch from github: 
    
      `gem 'spree_active_sale' , :git => 'git://github.com/suryart/spree_active_sale.git'`


  * Or get it from rubygems.org:
    

      `gem 'spree_active_sale'`

Then run the following commands: 

    $ bundle install
    $ rails g spree_active_sale:install 
    $ rake db:migrate
    $ rails s 


Example
=======

* Get a taxon in rails console:
    
    `taxon = Taxon.last`

* Create and *ActiveSale*: 

    `active_sale = Spree::ActiveSale.create name: "January 2013 sales"`
  output: 

    `#<Spree::ActiveSale id: 1, name: "January 2013 sales", created_at: "2013-01-20 20:33:57", updated_at: "2013-01-20 20:33:57">`

* Then create an *Event* under this sale by: 
    
    `event = taxon.active_sale_events.create name: "January 2013 sales", active_sale_id: active_sale.id, start_date: Time.now, end_date: Time.now+1.day, permalink: taxon.permalink `

* Now try to access this taxon in browser, there should be no other taxon/ product link accessible except the one we've created just now.


TODOs
=====

* Improve testing and write more test cases.
* Make an example applciation to show usage of this extension.
* Enhance the admin interface for active sales and events[U.I. and U.X.].
* Provide a timer hlper for showing the countdown to users.

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec

Contributing
============

1. [Fork](https://help.github.com/articles/fork-a-repo) the project
2. Make one or more well commented and clean commits to the repository. You can make a new branch here if you are modifying more than one part or feature.
3. Perform a [pull request](https://help.github.com/articles/using-pull-requests) in github's web interface.

NOTE
====

The current version supports Spree 1.3.0 or above. Older versions of Spree are unlikely to work, so attempt at your own risk.


License
---------
Copyright (c) 2013 Surya Tripathi, released under the New BSD License
