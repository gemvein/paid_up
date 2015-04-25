module ControllerMacros
  def access_anonymous
    sign_out :user
    assign(:current_subscriber, User.new)
  end

  def login_subscriber(subscriber)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in subscriber
    assign(:current_subscriber, subscriber)
  end
end