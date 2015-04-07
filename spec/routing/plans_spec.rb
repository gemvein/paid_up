require 'rails_helper'

describe SubscriptionFeatures::PlansController do
  routes { SubscriptionFeatures::Engine.routes }

  describe "routes to the list of all plans" do
    subject { get plans_path }

    it { should route_to(:controller => "subscription_features/plans", :action => "index")}
  end
end