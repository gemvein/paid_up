require "rails_helper"

RSpec.describe "paid_up/plans/index" do
  include_context 'loaded site'

  context 'when user is anonymous' do
    before do
      view.extend PaidUp::PlansHelper
      view.extend PaidUp::FeaturesHelper

      assign(:current_user, access_anonymous)
      assign(:plans, PaidUp::Plan.subscribable)
      render
    end
    context "displays the subscribable plans" do
      subject { rendered }
      it { should match /Free/ }
      it { should have_css '.free_subscribe_button .btn-success' }
      it { should match /No Ads/ }
      it { should have_css '.no_ads_subscribe_button .btn-success' }
      it { should match /Group Leader/ }
      it { should have_css '.group_leader_subscribe_button .btn-success' }
      it { should match /Professional/ }
      it { should have_css '.professional_subscribe_button .btn-success' }
      it { should_not match /Error/}
      it { should_not match /Anonymous/}
    end
  end

  context 'when user is logged in as professional subscriber' do
    before do
      view.extend PaidUp::PlansHelper
      view.extend PaidUp::FeaturesHelper

      assign(:current_user, login_subscriber(professional_subscriber))
      assign(:plans, PaidUp::Plan.subscribable)
      render
    end
    context "displays all the plans" do
      subject { rendered }
      it { should match /Free/ }
      it { should have_css '.free_subscribe_button .btn-danger' }
      it { should match /No Ads/ }
      it { should have_css '.no_ads_subscribe_button .btn-danger' }
      it { should match /Group Leader/ }
      it { should have_css '.group_leader_subscribe_button .btn-danger' }
      it { should match /Professional/ }
      it { should have_css '.professional_subscribe_button .btn-disabled' }
      it { should_not match /Error/}
      it { should_not match /Anonymous/}
    end
  end
end