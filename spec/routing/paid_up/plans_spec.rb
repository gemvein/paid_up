require 'rails_helper'

describe PaidUp::PlansController do
  routes { PaidUp::Engine.routes }

  describe "routes to the list of all plans" do
    subject { get plans_path }

    it { should route_to(:controller => "paid_up/plans", :action => "index")}
  end
end