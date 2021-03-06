# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'paid_up/plans/index' do
  include_context 'loaded site'

  before do
    view.extend PaidUp::PlansHelper
    view.extend PaidUp::FeaturesHelper
    view.extend BootstrapLeather::ApplicationHelper
  end

  context 'when user is anonymous' do
    before do
      assign(:current_user, access_anonymous)
      assign(:plans, PaidUp::Plan.subscribable)
      render
    end
    context 'displays the subscribable plans' do
      subject { rendered }
      it { should include 'Free' }
      it { should have_css '.free_subscribe_button .btn-success' }
      it { should include 'No Ads' }
      it { should have_css '.no_ads_subscribe_button .btn-success' }
      it { should include 'Group Leader' }
      it { should have_css '.group_leader_subscribe_button .btn-success' }
      it { should include 'Professional' }
      it { should have_css '.professional_subscribe_button .btn-success' }
      it { should_not include 'Error' }
      it { should_not include 'Anonymous' }
    end
  end

  context 'when user is logged in as professional subscriber' do
    before do
      assign(:current_user, login_subscriber(prof_subscriber))
      assign(:plans, PaidUp::Plan.subscribable)
      render
    end
    context 'displays all the plans' do
      subject { rendered }
      it { should include 'Free' }
      it { should have_css '.free_subscribe_button .btn-danger' }
      it { should include 'No Ads' }
      it { should have_css '.no_ads_subscribe_button .btn-danger' }
      it { should include 'Group Leader' }
      it { should have_css '.group_leader_subscribe_button .btn-danger' }
      it { should include 'Professional' }
      it { should have_css '.professional_subscribe_button .btn-disabled' }
      it { should_not include 'Error' }
      it { should_not include 'Anonymous' }
    end
  end
end
