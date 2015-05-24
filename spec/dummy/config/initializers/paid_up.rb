PaidUp.configure do |config|
  config.anonymous_customer_stripe_id = 'anonymous-customer'
  config.anonymous_plan_stripe_id = 'anonymous-plan'
  config.free_plan_stripe_id = 'free-plan'
end

PaidUp::Feature.new(
  slug: 'ad_free',
  title: 'Ad Free',
  description: 'Are ads removed from the site with this plan?',
  setting_type: 'boolean'
)
PaidUp::Feature.new(
  slug: 'groups',
  title: 'Groups',
  description: 'How many groups are allowed with this plan?',
  setting_type: 'rolify_rows'  # Enables table row counting that is enabled by a positive value
# for the PaidUp::FeaturesPlan.setting associated with this PaidUp::Feature
)
PaidUp::Feature.new(
  slug: 'doodads',
  title: 'Doodads',
  description: 'How many doodads included with this plan?',
  setting_type: 'table_rows'
)