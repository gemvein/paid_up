require 'rails_helper'

describe 'PaidUp::Routing' do
  describe "routes to the list of all plans" do
    subject { get plans_path }

    it { should route_to(:controller => "paid_up/plans", :action => "index")}
  end

  describe "routes to the subscription plan for a path" do
    subject { get plans_path }

    it { should route_to(:controller => "paid_up/plans", :action => "index")}
  end
end