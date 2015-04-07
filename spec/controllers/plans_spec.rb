require 'rails_helper'

RSpec.describe SubscriptionFeatures::PlansController do
  include_context 'plans and features'

  describe "GET #index" do
    before :each do
      get :index
    end
    context "responds successfully with an HTTP 200 status code" do
      subject { response }
      it { should be_success }
      it { should have_http_status(200) }
    end

    context "renders the index template" do
      subject { response }
      it { should render_template("index") }
    end

    context "loads all of the plans into @plans" do
      subject { assigns(:plans) }
      it { should eq(Plan.all) }
      it { should have(4).items }
    end
  end
end