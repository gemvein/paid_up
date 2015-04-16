require "rails_helper"

RSpec.describe "paid_up/subscriptions/new" do
  include_context 'plans and features'

  context 'when user is anonymous' do
    before do
      assign(:plan, professional_plan)
      assign(:subscription, User.new.build_subscription(plan: professional_plan))
      render
    end
    context "displays a signup form" do
      subject { rendered }
      # it { should match /Free/ }
      # it { should match /No Ads/ }
      # it { should match /Group Leader/ }
      # it { should match /Professional/ }
    end
  end
end