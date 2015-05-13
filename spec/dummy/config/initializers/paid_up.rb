PaidUp.configure do |config|
  config.current_subscriber_method = :current_user
  config.default_subscriber_method = :new_user
  config.anonymous_customer_stripe_id = 'anonymous-customer'
  config.free_plan_stripe_id = 'free-plan'
end

def new_user
  User.new
end