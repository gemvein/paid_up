# frozen_string_literal: true

PaidUp.configure do |config|
  config.anonymous_customer_stripe_id = 'anonymous-customer'
  config.anonymous_plan_stripe_id = 'anonymous-plan'
  config.free_plan_stripe_id = 'free-plan'

  PaidUp.add_feature(
    slug: 'ad_free', title: 'Ad Free', setting_type: 'boolean',
    description: 'Are ads removed from the site with this plan?'
  )
  PaidUp.add_feature(
    slug: 'groups', title: 'Groups', setting_type: 'rolify_rows',
    description: 'How many groups are allowed with this plan?'
    # Enables table row counting that is enabled by a positive value
    # for the PaidUp::PlanFeatureSetting.setting associated with this
    # PaidUp::Feature
  )
  PaidUp.add_feature(
    slug: 'doodads', title: 'Doodads', setting_type: 'table_rows',
    description: 'How many doodads included with this plan?'
  )
  PaidUp.add_feature(
    slug: 'posts', title: 'Posts', setting_type: 'table_rows',
    description: 'How many posts included with this plan?'
  )
end
