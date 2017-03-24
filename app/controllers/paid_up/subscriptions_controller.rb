module PaidUp
  # Subscriptions Controller
  class SubscriptionsController < PaidUpController
    before_action :authenticate_user!
    before_action :set_plan, only: [:new, :create]

    def index
      # nothing to do, everything we need is in current_user
    end

    def new
      # nothing to do, @plan set by #set_plan
      (current_user.can_downgrade_to?(@plan) || @plan.amount.zero?) && create
    end

    def create
      # @plan set by #set_plan
      current_user.update_attribute(:coupon_code, params[:coupon_code])
      if current_user.subscribe_to_plan(@plan, params[:stripeToken])
        subscription_id = current_user.stripe_data.subscriptions.first.id
        discount = current_user.stripe_data.discount
        if !discount.nil? && !discount.coupon.nil? && @plan.amount != 0
          orig_amount = @plan.amount
          amount = orig_amount
          amount -= (discount.coupon.percent_off || 0) * 0.01 * amount
          amount -= (discount.coupon.amount_off || 0)
          amount = amount > 0 ? amount : 0
          money = Money.new(amount, @plan.currency)
        else
          money = @plan.money
        end
        flash[:paid_up_google_analytics_data] = {
          transactionId: subscription_id,
          transactionTotal: money.dollars,
          transactionProducts: [
            sku: @plan.stripe_id,
            name: @plan.title,
            price: @plan.money.dollars,
            quantity: '1'
          ]
        }
        redirect_to(
          subscriptions_path,
          flash: {
            notice: :you_are_now_subscribed_to_the_plan.l(
              plan_name: current_user.plan.title
            )
          }
        )
      else
        redirect_to(
          new_plan_subscription_path(@plan),
          flash: {
            error: current_user.errors.full_messages ||
                   :could_not_subscribe_to_plan.l(plan: @plan.title)
          }
        )
      end
    rescue Stripe::InvalidRequestError => e
      flash[:error] = e.message
      redirect_to subscriptions_path
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
