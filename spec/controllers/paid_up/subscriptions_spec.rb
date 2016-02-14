require 'rails_helper'


RSpec.describe PaidUp::SubscriptionsController do
  include_context 'loaded site'
  routes { PaidUp::Engine.routes }

  describe 'GET #index' do
    context 'when the user is anonymous' do
      before do
        access_anonymous
        get :index
      end
      context 'redirects to the user sign up page' do
        subject { response }
        it { should redirect_to '/users/sign_in' }
        it { should have_http_status(302) }
      end
    end
    context 'when the user is signed in as a subscriber' do
      before do
        sign_in free_subscriber
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
    end
  end

  describe "GET #new" do
    context "when the user is anonymous" do
      before do
        access_anonymous
        get :new, plan_id: professional_plan.id
      end
      context 'redirects to the user sign up page' do
        subject { response }
        it { should redirect_to '/users/sign_in' }
        it { should have_http_status(302) }
      end
    end
    context "when the user is signed in" do
      context 'when upgrading' do
        context 'with a paid plan' do
          before do
            sign_in free_subscriber
            get :new, plan_id: professional_plan.id
          end
          after do
            free_subscriber.subscribe_to_plan free_plan
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
        context 'with the free plan' do
          before do
            login_subscriber no_ads_subscriber
            get :new, plan_id: free_plan.id
          end
          after do
            no_ads_subscriber.subscribe_to_plan no_ads_plan
          end
          context "redirects to the subscriptions index page" do
            subject { response }
            it { should redirect_to subscriptions_path }
            it { should have_http_status(302) }
          end
          context "sets a flash message" do
            subject { flash[:notice] }
            it { should match /You are now subscribed to the #{free_plan.title} Plan/ }
          end
        end
        context 'when downgrading' do
          before do
            sign_in professional_subscriber
            get :new, plan_id: no_ads_plan.id
          end
          after do
            professional_subscriber.subscribe_to_plan professional_plan
          end
          context "redirects to the subscriptions index page" do
            subject { response }
            it { should redirect_to subscriptions_path }
            it { should have_http_status(302) }
          end
          context "sets a flash message" do
            subject { flash[:notice] }
            it { should match /You are now subscribed to the #{no_ads_plan.title} Plan/ }
          end
        end
      end
    end
  end

  describe "POST #create" do
    context "when the user is anonymous" do
      before do
        access_anonymous
        get :index
      end
      context 'redirects to the user sign up page' do
        subject { response }
        it { should redirect_to '/users/sign_in' }
        it { should have_http_status(302) }
      end
    end
    context "when the user is signed in" do
      context "upgrading from the free plan" do
        context 'without a coupon code' do
          before do
            sign_in free_subscriber
            token = working_stripe_token free_subscriber
            post :create, plan_id: professional_plan.id, stripeToken: token
          end
          after do
            free_subscriber.subscribe_to_plan free_plan
          end
          context "redirects to the subscriptions index page" do
            subject { response }
            it { should redirect_to subscriptions_path }
            it { should have_http_status(302) }
          end
          context "sets a flash message" do
            subject { flash[:notice] }
            it { should match /You are now subscribed to the #{professional_plan.title} Plan/ }
          end
        end
        context 'with a coupon code' do
          before do
            sign_in free_subscriber
            token = working_stripe_token free_subscriber
            post :create, plan_id: professional_plan.id, stripeToken: token, coupon_code: '25OFF'
          end
          after do
            free_subscriber.subscribe_to_plan free_plan
          end
          context "redirects to the subscriptions index page" do
            subject { response }
            it { should redirect_to subscriptions_path }
            it { should have_http_status(302) }
          end
          context "sets a flash message" do
            subject { flash[:notice] }
            it { should match /You are now subscribed to the #{professional_plan.title} Plan/ }
          end
        end
      end

      context "upgrading from the no ads plan" do
        context 'without a coupon code' do
          before do
            sign_in no_ads_subscriber
            post :create, plan_id: professional_plan.id
          end
          after do
            no_ads_subscriber.subscribe_to_plan no_ads_plan
          end
          context "redirects to the subscriptions index page" do
            subject { response }
            it { should redirect_to subscriptions_path }
            it { should have_http_status(302) }
          end
          context "sets a flash message" do
            subject { flash[:notice] }
            it { should match /You are now subscribed to the #{professional_plan.title} Plan/ }
          end
        end
        context 'with a coupon code' do
          before do
            sign_in no_ads_subscriber
            post :create, plan_id: professional_plan.id, coupon_code: 'MINUS25'
          end
          after do
            no_ads_subscriber.subscribe_to_plan no_ads_plan
          end
          context "redirects to the subscriptions index page" do
            subject { response }
            it { should redirect_to subscriptions_path }
            it { should have_http_status(302) }
          end
          context "sets a flash message" do
            subject { flash[:notice] }
            it { should match /You are now subscribed to the Professional Plan/ }
          end
        end
      end
    end
  end
end