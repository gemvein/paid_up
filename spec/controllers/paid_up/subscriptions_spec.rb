require 'rails_helper'


RSpec.describe PaidUp::SubscriptionsController do
  routes { PaidUp::Engine.routes }

  describe "GET #new" do
    context "when the user is anonymous" do
      include_context 'plans and features'
      before :each do
        get :new, plan_id: professional_plan.id
      end
      context 'redirects to the user sign up page' do
        subject { response }
        it { should redirect_to '/users/sign_in' }
        it { should have_http_status(302) }
      end
    end
    context "when the user is signed in" do
      include_context 'subscribers'
      before :each do
        sign_in free_subscriber
        get :new, plan_id: professional_plan.id
      end
      context "responds successfully with an HTTP 200 status code" do
        subject { response }
        it { should be_success }
        it { should have_http_status(200) }
      end
      context "renders the new template" do
        subject { response }
        it { should render_template("new") }
      end
      context "loads the requested plan into @plan" do
        subject { assigns(:plan) }
        it { should eq(professional_plan) }
      end
    end
  end
end