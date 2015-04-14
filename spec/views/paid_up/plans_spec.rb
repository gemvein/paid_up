require "rails_helper"

RSpec.describe "paid_up/plans/index" do
  include_context 'plans and features'
  context 'when user is anonymous' do
    before do
      assign(:current_subscriber, User.new)
      assign(:plans, PaidUp::Plan.all)
      render
    end
    context "displays all the plans" do
      subject { rendered }
      it { should match /Free/ }
      it { should match /No Ads/ }
      it { should match /Group Leader/ }
      it { should match /Professional/ }
    end
  end
end