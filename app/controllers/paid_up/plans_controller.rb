module PaidUp
  class PlansController < PaidUpController
    def index
      @plans = PaidUp::Plan.subscribable
    end
  end
end