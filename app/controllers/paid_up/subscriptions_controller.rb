module PaidUp
  class SubscriptionsController < PaidUpController
    before_filter :authenticate_user!
    before_filter :set_plan, only: [:new, :create]
    def new
      # nothing to do, plan set by #set_plan
    end

    def create
      # nothing to do, plan set by #set_plan

      customer = Stripe::Customer.create(
          :source => params[:stripeToken],
          :plan => @plan.stripe_id,
          :email => @current_subscriber.email
      )

      @current_subscriber.update_attributes(stripe_id: customer.id)

      @current_subscriber.load_stripe_data

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