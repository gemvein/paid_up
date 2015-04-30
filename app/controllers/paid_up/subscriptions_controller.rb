module PaidUp
  class SubscriptionsController < PaidUpController
    before_filter :authenticate_user!
    before_filter :set_plan, only: [:new, :create]
    def new
      # nothing to do, @plan set by #set_plan
    end

    def create
      # @plan set by #set_plan
      @current_subscriber.subscribe_to_plan(params[:stripeToken], @plan)

      redirect_to subscriptions_path, flash: { notice: :you_are_now_subscribed_to_the_plan.l(plan_name: @current_subscriber.plan.name) }
    rescue Stripe::InvalidRequestError => e
      flash[:error] = e.message
      redirect_to plans_path
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_plan_subscription_path
    end

    private
    def set_plan
      @plan = PaidUp::Plan.find(params[:plan_id])
    end
  end
end