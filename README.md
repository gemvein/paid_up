Paid Up
===========

[![GitHub version](https://badge.fury.io/gh/gemvein%2Fpaid_up.svg)](http://badge.fury.io/gh/gemvein%2Fpaid_up)
[![Build Status](https://travis-ci.org/gemvein/paid_up.svg)](https://travis-ci.org/gemvein/paid_up)
[![Coverage Status](https://coveralls.io/repos/gemvein/paid_up/badge.png)](https://coveralls.io/r/gemvein/paid_up)

Paid Up is a start-to-finish Stripe subscription engine. You set up the plans you want on Stripe, and the gem gives you a way to tie those plans to authenticated users, granting them abilities based on the features outlined for their plan.

* Ruby 2, Rails 4
* Authentication by Devise
* Authorization by CanCan
* Subscription by Stripe
* Assumes you will be using some variety of Bootstrap, and designed to be quite responsive out of the box, but included views can be overridden with custom views.

Installation
----------------------------
First you need a working user-type model, with any authentication system you like. I recommend the gem 'devise' for this. Once you have your model in place, add paid_up to your `Gemfile`:

    gem 'paid_up'
    
If you do not have a table and model for your users/subscribers, now would be the time to create one. You can name it as you like; `User` would be logical. You do not need to include columns for authentication functionality, as those will be included when Devise is installed, which happens automatically during the upcoming steps. Just put in the fields that relate to your own functionality, such as profile columns.

Next, install PaidUp for your user model by executing these commands:

    bundle install
    rails g paid_up:install [USER_MODEL_NAME]
    rake db:migrate
    
Configuration
----------------------------    

Edit your config file at `config/initializers/paid_up.rb` to set up some other key details.

Set your environment variables with your STRIPE_PUBLISHABLE_KEY and your STRIPE_SECRET_KEY. (Check your operating system or IDE's documentation for details)

Stripe Setup
----------------------------

Using your own code or Stripe's convenient web interface, add the plans you intend to offer. Each will also need a record in your own database, so for each `Stripe::Plan` you create, note the `id` and use it as the `stripe_id` in the corresponding `PaidUp::Plan`. At a minimum, you will need an anonymous plan, a free plan, both with a cost amount of `0`; and also at least one paid plan.

Next, add a `Stripe::Customer` to serve as the Anonymous User, and subscribe that customer to the anonymous plan. Note the customer's `id` and copy that into your stripe configuration file.

Features Setup
----------------------------

Set up each `PaidUp::Feature` using your own admin, the console, or seed data. Associate the features with the corresponding plans using the `PaidUp::FeaturesPlan` joining table model. For example, check out the seeds files in [`spec/dummy/db/seeds/`](spec/dummy/db/seeds/)

Contributing to Paid Up
----------------------------
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
---------

Copyright (c) 2015 Gem Vein. See LICENSE.txt for further details.

