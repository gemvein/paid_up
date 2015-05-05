require "rails_helper"

RSpec.describe "paid_up/subscriptions/new" do
  context 'when user is logged in as new customer' do
    include_context 'subscribers'
    context "displays a payment form" do
      before do
        view.extend PaidUp::PlansHelper

        assign(:current_subscriber, login_subscriber(free_subscriber))
        assign(:plan, professional_plan)
        render
      end
      subject { rendered }
      it { should match /Professional/ }
      it { should have_selector 'form' }
      it { should match /#{paid_up.plan_subscriptions_path(professional_plan.id)}/ }
    end
  end
  context 'when user is logged in as established customer' do
    include_context 'subscribers'
    context "displays a payment form" do
      before do
        view.extend PaidUp::PlansHelper

        assign(:current_subscriber, no_ads_subscriber(free_subscriber))
        assign(:plan, professional_plan)
        render
      end
      subject { rendered }
      it { should match /Professional/ }
      it { should have_selector 'form' }
      it { should match /#{paid_up.plan_subscriptions_path(professional_plan.id)}/ }
    end
  end
end

RSpec.describe "paid_up/subscriptions/index" do
  context 'when user is logged in' do
    include_context 'subscribers'
    context "displays the details of a user's subscriptions" do
      before do
        view.extend PaidUp::PlansHelper

        assign(:current_subscriber, login_subscriber(professional_subscriber))
        render
      end
      subject { rendered }
      it { should match /Professional/ }
    end
  end
end