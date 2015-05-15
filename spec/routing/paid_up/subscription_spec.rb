require 'rails_helper'

describe 'PaidUp::Routing' do
  include_context 'plans and features'
  routes { PaidUp::Engine.routes }

  describe 'nested resource' do
    context "routes to a new subscription for a plan" do
      subject { get new_plan_subscription_path(professional_plan) }
      it { should route_to(:controller => "paid_up/subscriptions", :action => "new", :plan_id => professional_plan.id.to_s) }
    end
    context "routes to create a subscription for a plan" do
      subject { post plan_subscriptions_path(professional_plan) }
      it { should route_to(:controller => "paid_up/subscriptions", :action => "create", :plan_id => professional_plan.id.to_s) }
    end
  end
  describe 'top-level resource' do
    context "routes to a display of subscriptions for a user" do
      subject { get subscriptions_path }
      it { should route_to(:controller => "paid_up/subscriptions", :action => "index") }
    end
  end
end