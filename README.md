Paid Up
===========

[![GitHub version](https://badge.fury.io/gh/gemvein%2Fpaid_up.svg)](http://badge.fury.io/gh/gemvein%2Fpaid_up)
[![Build Status](https://travis-ci.org/gemvein/paid_up.svg)](https://travis-ci.org/gemvein/paid_up)
[![Coverage Status](https://coveralls.io/repos/gemvein/paid_up/badge.png)](https://coveralls.io/r/gemvein/paid_up)

Installation
----------------------------
First you need a working user-type model, with any authentication system you like. I recommend the gem 'devise' for this. Once you have your model in place, add paid_up to your `Gemfile`:

    gem 'paid_up'

Next, install it by executing these commands:

    bundle install
    rails g paid_up:install [USER_MODEL_NAME]
    rake db:migrate

Edit your config file at `config/initializers/paid_up.rb` to set up your connection to Stripe, as well as some other key details.

Set your environment variables with your STRIPE_PUBLISHABLE_KEY and your STRIPE_SECRET_KEY. (Check your operating system or IDE's documentation for details)

Using your own code or Stripe's convenient web interface, add the plans you intend to offer. Each will also need a record in your own database. For each Stripe::Plan you create, note the `id` and use it as the `stripe_id` in the corresponding `PaidUp::Plan`. At a minimum, you will need an anonymous plan, a free plan, both with a cost amount of `0`; and also at least one paid plan.

Next, add a `Stripe::Customer` to serve as the Anonymous User, and subscribe that customer to the anonymous plan. Note the customer's `id` and copy that into your stripe configuration file.

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

