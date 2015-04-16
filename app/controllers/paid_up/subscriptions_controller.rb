module PaidUp
  class SubscriptionsController < PaidUpController
    before_filter :authenticate_user!
    def new
      @plan = PaidUp::Plan.find(params[:plan_id])
    end
  end
end