module ControllerMacros
  def access_anonymous
    sign_out :user
    assign(:current_subscriber, User.new)
  end

  def login_subscriber(subscriber)
    include_context 'subscribers'
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in subscriber
    end
  end
end