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

