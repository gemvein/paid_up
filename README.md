# Paid Up

[![GitHub version](https://badge.fury.io/gh/gemvein%2Fpaid_up.svg)](http://badge.fury.io/gh/gemvein%2Fpaid_up)
[![Build Status](https://travis-ci.org/gemvein/paid_up.svg)](https://travis-ci.org/gemvein/paid_up)
[![Coverage Status](https://coveralls.io/repos/gemvein/paid_up/badge.png)](https://coveralls.io/r/gemvein/paid_up)

Paid Up is a start-to-finish Stripe subscription engine. You set up the plans and coupons you want on Stripe, and the gem gives you a way to tie those plans and coupons to authenticated users, granting them abilities based on the features outlined for their plan.

* Ruby 2, Rails 4 through Rails 6
* Authentication by Devise
* Authorization by CanCanCan
* Subscription by Stripe
* Roles by Rolify
* Uses Google Tag Manager for Google Analytics `dataLayer` object to provide e-commerce analytics.
* Assumes you will be using some variety of Bootstrap, and designed to be quite responsive out of the box. Included views can be overridden with custom views.

### Plans Index Page
![Plans Index Page Screenshot](http://gemvein.com/assets/screenshots/paid_up-plans-index.png)

### New Subscription Page
![New Subscription Page Screenshot](http://gemvein.com/assets/screenshots/paid_up-subscriptions-new.png)

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

Set your stripe credentials using `rails credentials:edit`. It is recommended that you use a restricted key. The key needs to have write access to customers and checkout.

```yaml
production:
  stripe:
    publishable_key: 'PUT YOUR PRODUCTION PUBLISHABLE KEY HERE'
    secret_key: 'PUT YOUR PRODUCTION SECRET KEY HERE'
development:
  stripe:
    publishable_key: 'PUT YOUR DEVELOPMENT PUBLISHABLE KEY HERE'
    secret_key: 'PUT YOUR DEVELOPMENT SECRET KEY HERE'
```

(The old environment variables will still work, but this use is not recommended)

## Stripe Setup

Using your own code or Stripe's convenient web interface, add the plans and coupons you intend to offer.

Each plan will also need a record in your own database, so for each `Stripe::Plan` you create, note the `id` for its free price and use it as the `stripe_id` in the corresponding `PaidUp::Plan`. At a minimum, you will need an anonymous plan, a free plan, both with a cost amount of `0`; and also at least one paid plan.

Coupons do not need any further configuration, other than adding them to your Stripe Account.

Next, add a `Stripe::Customer` to serve as the Anonymous User, and subscribe that customer to the anonymous plan. Note the customer's `id` and copy that into your stripe configuration file.

Pay close attention to the settings in `Account Settings` under `Subscriptions` and `Emails`, as they have a big effect on how your site behaves.

## Features Setup

Set up each `PaidUp::Feature` using the config file. (A config file is used rather than using records in an `ActiveRecord::Base` model because relationships cannot be created at runtime.) Associate the features with the corresponding plans using the `PaidUp::PlanFeatureSetting` model. For an example, check out the seeds file at [`spec/dummy/db/seeds.db`](spec/dummy/db/seeds.db)

Possible `:setting_type` values are: `boolean`, `table_rows`, `rolify_rows`. The latter two require a table corresponding to the feature's `:name` value. 

#### Setting Type: Table Rows

In the `table_rows` case, the table and its model must exist. the table should have a `:user_id` column, then you need to add `paid_for` to the model, and from there the appropriate `has_many` and `belongs_to` relationships will be created for you.

#### Setting Type: Rolify Rows
    
In the `rolify_rows` case, the table and its model must also exist. Once that is done and the corresponding `PaidUp::Feature` is created, add `paid_for` to the model. This means the resource model will run the `resourcify` method, and the User method will have had the `rolify` method added to it during install, so no further setup is required.

#### Scope

If you only want to count certain records against a user's tally, for example only records with `active` set to `true`, you can add the scope option with a symbol corresponding to the desired method or scope, like so:

    class Post < ActiveRecord::Base
      paid_for scope: :active
      scope :active, -> { where(active: true) }
    end


## Enabling Javascript

In order for PaidUp's AJAX functionality to work (which is required because Stripe uses AJAX), you will need to add this to your layout file, preferably near the end of the <body> element (for speed reasons):

    = render_footer_javascript
    
## Abilities

Abilities corresponding to features you have defined will be generated automatically, as an `:own` ability on the specified tables, plus rational defaults for `:manage`, `:index` and `:show` permissions, if you include the `PaidUp::Ability` module and use the `initialize_paid_up(user)` command, like this:

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
    
## Speeding up User queries

If you try generating a list of users (such as for display in a user directory), you may find
that the Stripe checking code slows down your query significantly.

To avoid this, add "select(:field_1, :field_2, :etc)" to your finder, being
sure to *omit* the :stripe_id column.

Another option would be to create a Person model that inherits from the User model but omits the :stripe_id column 
(as above) in its `default_scope`. You can use this Person object for queries related to directory or profile display, 
thereby speeding up all queries not requiring plan information. 
    
## Controller

Your controller should inherit from PaidUp::PaidUpController, which in turn inherits from your own ApplicationController.
    
    class GroupsController < PaidUp::PaidUpController
    
### Models

Your user model will need to call the `subscriber` method (this is done for you at install). 

The resources referred to in your config will need to call `paid_for`, like this:

    class Group < ActiveRecord::Base
      paid_for
    end
    
### Enabling Google Analytics
    
In your application controller, add:

    helper PaidUp::PaidUpHelper

In your layout view, include the following code snippet, which will only fire when a subscription is made. 

This needs to go above your call to Google Tag Manager, so that the data in it is available to GTM.

    = paid_up_google_analytics_data_layer
    
Doing this will populate the e-commerce data in Google Analytics, but you must also have that feature turned on.

### Upgrading

#### Version 0.13
Updated to use Stripe's "Price" system instead of the old "Plan" system. Keys will need to be updated.

#### Version 0.12.1
Renamed `subscription` to `paid_up_subscription` and `subscriptions` to `paid_up_subscriptions` to avoid naming conflicts with other gems.

#### Version 0.12.0

Version 0.12.0 requires Ruby 2.3 or higher because of the use of the `&.` operator.

##### paid_for Mixin

The methods `table_rows` and `rolify_rows` were renamed to `table_setting(table_name).rows_count` and `rolify_setting(table_name).rows_count`, replaced by methods that fetch the rows themselves.

All previous methods beginning with `table_rows_` and `rolify_rows_` have also been moved into `table_setting()` and `rolify_setting()`

The method `enabled` was renamed to `enabled?`.

#### Version 0.9.0

Version 0.9.0 enabled coupon codes, which are saved on the user's record. Be sure to run `rake paid_up:install:migrations` and migrate your database after upgrading.

#### Version 0.8.0

Version 0.8.0 introduced database changes to the foreign key columns to work with namespacing in Rails 4.2.5:

`paid_up_plan_feature_settings`.`plan_id` must be changed to `paid_up_plan_feature_settings`.`paid_up_plan_id`.

## Contributing to Paid Up
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Contributors
* [Karen Lundgren](https://github.com/nerakdon)
* [Chad Lundgren](https://github.com/chadlundgren)

## Copyright

Copyright (c) 2015-2017 [Gem Vein](https://www.gemvein.com). See LICENSE.txt for further details.

