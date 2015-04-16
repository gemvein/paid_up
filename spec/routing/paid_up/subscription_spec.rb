require 'rails_helper'

describe 'PaidUp::Routing' do
  include_context 'plans and features'
  routes { PaidUp::Engine.routes }

  describe "routes to the subscription plan for a path" do
    subject { get new_plan_subscription_path(professional_plan) }

    it { should route_to(:controller => "paid_up/subscriptions", :action => "new", :plan_id => professional_plan.id.to_s)}
  end
end