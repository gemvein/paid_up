require 'rails_helper'

describe 'PaidUp::Routing' do
  include_context 'plans and features'
  routes { PaidUp::Engine.routes }

  describe "routes to the list of all plans" do
    subject { get plans_path }

    it { should route_to(:controller => "paid_up/plans", :action => "index")}
  end

  describe "routes to the subscription plan for a path" do
    subject { get subscribe_plan_path(professional_plan) }

    it { should route_to(:controller => "paid_up/plans", :action => "subscribe", :id => professional_plan.id.to_s)}
  end
end