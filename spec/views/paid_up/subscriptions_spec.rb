require "rails_helper"

RSpec.describe "paid_up/subscriptions/new" do
  context 'when user is logged in' do
    include_context 'subscribers'
    context "displays a payment form" do
      before do
        login_subscriber free_subscriber
        assign(:plan, professional_plan)
        render
      end
      subject { rendered }
      it { should match /Professional/ }
    end
  end
end