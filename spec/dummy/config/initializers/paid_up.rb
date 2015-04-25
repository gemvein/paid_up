PaidUp.configure do |config|
  config.current_subscriber_method = :current_user
  config.default_subscriber_method = :new_user
end

def new_user
  User.new
end