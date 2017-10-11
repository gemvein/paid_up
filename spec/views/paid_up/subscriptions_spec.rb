# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'paid_up/subscriptions/new' do
  include_context 'loaded site'

  before do
    view.extend PaidUp::PlansHelper
    view.extend PaidUp::FeaturesHelper
    view.extend BootstrapLeather::ApplicationHelper
  end

  context 'when user is logged in as free customer' do
    context 'displays a payment form' do
      before do
        assign(:current_user, login_subscriber(free_subscriber))
        assign(:plan, professional_plan)
        render
      end
      subject { rendered }
      it { should include 'Professional' }
      it { should have_selector 'form' }
      it do
        should include paid_up.plan_subscriptions_path(professional_plan.id)
      end
    end
  end
  context 'when user is logged in as a paid customer' do
    context 'displays a payment form' do
      before do
        assign(:current_user, login_subscriber(no_ads_subscriber))
        assign(:plan, professional_plan)
        render
      end
      subject { rendered }
      it { should include 'Professional' }
      it { should have_selector 'form' }
      it do
        should include paid_up.plan_subscriptions_path(professional_plan.id)
      end
    end
  end
end

RSpec.describe 'paid_up/subscriptions/index' do
  include_context 'loaded site'

  before do
    view.extend PaidUp::PlansHelper
    view.extend PaidUp::FeaturesHelper
    view.extend BootstrapLeather::ApplicationHelper
  end

  context 'when user is logged in' do
    context "displays the details of a user's subscriptions" do
      before do
        assign(:current_user, login_subscriber(leader_subscriber))
        render
      end
      subject { rendered }
      it { should include 'Group Leader' }
      it { should have_css 'table.abilities #ad_free_ability .glyphicon-ok' }
      it { should have_css 'table.abilities #groups_ability .glyphicon-ok' }
      it { should have_css 'table.abilities #doodads_ability .glyphicon-ok' }
    end
  end
end
