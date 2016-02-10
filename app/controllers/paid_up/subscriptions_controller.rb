module PaidUp
  class SubscriptionsController < PaidUpController
    before_filter :authenticate_user!
    before_filter :set_plan, only: [:new, :create]

    def index
      # nothing to do, everything we need is in current_user
    end

    def new
      # nothing to do, @plan set by #set_plan
      if current_user.can_downgrade_to? @plan || @plan.amount == 0
        create
      end
    end

    def create
      # @plan set by #set_plan
      current_user.update_attribute(:coupon_code, params[:coupon_code])
      if current_user.subscribe_to_plan(@plan, params[:stripeToken])
        redirect_to subscriptions_path, flash: { notice: :you_are_now_subscribed_to_the_plan.l(plan_name: current_user.plan.title) }
      else
        redirect_to new_plan_subscription_path @plan, flash: { error: current_user.errors.full_messages || :could_not_subscribe_to_plan.l(plan: @plan.title) }
      end
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