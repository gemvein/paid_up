# Paid Up

[![GitHub version](https://badge.fury.io/gh/gemvein%2Fpaid_up.svg)](http://badge.fury.io/gh/gemvein%2Fpaid_up)
[![Build Status](https://travis-ci.org/gemvein/paid_up.svg)](https://travis-ci.org/gemvein/paid_up)
[![Coverage Status](https://coveralls.io/repos/gemvein/paid_up/badge.png)](https://coveralls.io/r/gemvein/paid_up)

Paid Up is a start-to-finish Stripe subscription engine. You set up the plans you want on Stripe, and the gem gives you a way to tie those plans to authenticated users, granting them abilities based on the features outlined for their plan.

* Ruby 2, Rails 4
* Authentication by Devise
* Authorization by CanCan
* Subscription by Stripe
* Roles by Rolify
* Assumes you will be using some variety of Bootstrap, and designed to be quite responsive out of the box, but included views can be overridden with custom views.

## Installation

First, add paid_up to your `Gemfile`:

    gem 'paid_up'
    
To start with, you will need a User model and the corresponding table, set up with your business rules for users, such as profile fields or theme configuration.

    rails generate model User name:string:unique bio:text

Next, install PaidUp for your user model by executing these commands:

    bundle install
    rails g paid_up:install
    rake db:migrate
    
## Configuration
    
Edit your config file at `config/initializers/paid_up.rb` to set up some other key details.

Set your environment variables with your STRIPE_PUBLISHABLE_KEY and your STRIPE_SECRET_KEY. (Check your operating system or IDE's documentation for details)

## Stripe Setup

Using your own code or Stripe's convenient web interface, add the plans you intend to offer. Each will also need a record in your own database, so for each `Stripe::Plan` you create, note the `id` and use it as the `stripe_id` in the corresponding `PaidUp::Plan`. At a minimum, you will need an anonymous plan, a free plan, both with a cost amount of `0`; and also at least one paid plan.

Next, add a `Stripe::Customer` to serve as the Anonymous User, and subscribe that customer to the anonymous plan. Note the customer's `id` and copy that into your stripe configuration file.

## Features Setup

Set up each `PaidUp::Feature` using the config file. (A config file is used rather than using records in an `ActiveRecord::Base` model because relationships cannot be created at runtime.) Associate the features with the corresponding plans using the `PaidUp::PlanFeatureSetting` model. For an example, check out the seeds file at [`spec/dummy/db/seeds.db`](spec/dummy/db/seeds.db)

Possible `:setting_type` values are: `boolean`, `table_rows`, `rolify_rows`. The latter two require that a table corresponding to the feature's `:name` value. 

#### Setting Type: Table Rows

In the `table_rows` case, the table and its model must exist. the table should have a `:user_id` column, and from there the appropriate `has_many` and `belongs_to` relationships will be created for you.

#### Setting Type: Rolify Rows
    
In the `rolify_rows` case, the table and its model must also exist. Once that is done and the corresponding `PaidUp::Feature` is created, the resource model will run the `resourcify` method, and the User method will have had the `rolify` method added to it during install, so no further setup is required.

## Enabling Javascript

In order for PaidUp's AJAX functionality to work (which is required because Stripe uses AJAX), you will need to add this to your layout file, preferably near the end of the <body> element (for speed reasons):

    = render_footer_javascript
    
## Abilities

Abilities corresponding to features you have defined will be generated automatically, as an `:own` ability on the specified tables, plus rational defaults for `:manage` and `:read` permissions, if you include the `PaidUp::Ability` module and use the `initialize_paid_up(user)` command, like this:

    # /app/models/ability.rb
    class Ability
      include CanCan::Ability
      include PaidUp::Ability
    
      def initialize(user)
        user ||= User.new # anonymous user (not logged in)
    
        # Rails Application's initialization could go here.
    
        initialize_paid_up(user)
      end
    end

## Contributing to Paid Up
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright
---------

Copyright (c) 2015 Gem Vein. See LICENSE.txt for further details.

