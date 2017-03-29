# frozen_string_literal: true

module PaidUp
  # Subscriptions Controller
  class SubscriptionsController < PaidUpController
    before_action :authenticate_user!
    before_action :load_plan, only: %i(new create)

    rescue_from Stripe::InvalidRequestError do |error|
      invalid_request_error(error)
    end
    rescue_from Stripe::CardError do |error|
      invalid_card_error(error)
    end

    def index
      # nothing to do, everything we need is in current_user
    end

    def new
      # nothing to do, @plan load by #load_plan
      (current_user.can_downgrade_to?(@plan) || @plan.amount.zero?) && create
    end

    def create
      # @plan load by #load_plan
      result = current_user.subscribe_to_plan(
        @plan,
        params[:stripeToken],
        params[:coupon_code]
      )
      if result
        create_success
      else
        create_error
      end
    end

    private

    def create_success
      google_analytics_flash
      flash[:notice] = :you_are_now_subscribed_to_the_plan.l(
        plan_name: current_user.plan.title
      )
      redirect_to subscriptions_url
    end

    def create_error
      flash[:error] = current_user.errors.full_messages ||
                      :could_not_subscribe_to_plan.l(plan: @plan.title)
      redirect_to new_plan_subscription_url(@plan)
    end

    def invalid_request_error(e)
      flash[:error] = e.message
      redirect_to subscriptions_path
    end

    def invalid_card_error(e)
      flash[:error] = e.message
      redirect_to new_plan_subscription_path
    end

    def load_plan
      @plan = PaidUp::Plan.find(params[:plan_id])
    end

    def google_analytics_flash
      stripe_data = current_user.stripe_data
      discount = stripe_data.discount
      flash[:paid_up_google_analytics_data] = {
        transactionId: stripe_data.subscriptions.first.id,
        transactionTotal: @plan.adjusted_money(discount).dollars,
        transactionProducts: [
          sku: @plan.stripe_id, name: @plan.title, price: @plan.money.dollars,
          quantity: '1'
        ]
      }
    end
  end
end
