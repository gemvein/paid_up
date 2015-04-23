require "rails_helper"

RSpec.describe "paid_up/plans/index" do
  include_context 'subscribers'

  context 'when user is anonymous' do
    before do
      access_anonymous
      assign(:plans, PaidUp::Plan.all)
      render
    end
    context "displays all the plans" do
      subject { rendered }
      it { should match /Free/ }
      it { should have_css '.free_subscribe_button .btn-info' }
      it { should match /No Ads/ }
      it { should have_css '.no_ads_subscribe_button .btn-success' }
      it { should match /Group Leader/ }
      it { should have_css '.group_leader_subscribe_button .btn-success' }
      it { should match /Professional/ }
      it { should have_css '.professional_subscribe_button .btn-success' }
      it { should_not match /Error/}
    end
  end

  context 'when user is logged in as professional subscriber' do
    before do
      sign_in professional_subscriber
      assign(:current_subscriber, professional_subscriber)
      assign(:plans, PaidUp::Plan.all)
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
    end
  end
end