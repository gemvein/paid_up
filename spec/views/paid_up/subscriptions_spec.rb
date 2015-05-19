require "rails_helper"

RSpec.describe "paid_up/subscriptions/new" do
  context 'when user is logged in as free customer' do
    include_context 'subscribers'
    context "displays a payment form" do
      before do
        view.extend PaidUp::PlansHelper
        view.extend PaidUp::FeaturesHelper

        assign(:current_user, login_subscriber(free_subscriber))
        assign(:plan, professional_plan)
        render
      end
      subject { rendered }
      it { should match /Professional/ }
      it { should have_selector 'form' }
      it { should match /#{paid_up.plan_subscriptions_path(professional_plan.id)}/ }
    end
  end
  context 'when user is logged in as a paid customer' do
    include_context 'subscribers'
    context "displays a payment form" do
      before do
        view.extend PaidUp::PlansHelper
        view.extend PaidUp::FeaturesHelper

        assign(:current_user, login_subscriber(no_ads_subscriber))
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
        view.extend PaidUp::FeaturesHelper

        assign(:current_user, login_subscriber(group_leader_subscriber))
        render
      end
      subject { rendered }
      it { should match /Group Leader/ }
      it { should have_selector 'table.abilities #ad_free_ability .glyphicon-ok'}
      it { should have_selector 'table.abilities #groups_ability .glyphicon-ok'}
      it { should have_selector 'table.abilities #calendar_ability .glyphicon-remove'}
    end
  end
end