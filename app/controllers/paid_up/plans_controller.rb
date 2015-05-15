module PaidUp
  class PlansController < PaidUpController
    def index
      @features = PaidUp::Feature.all
      @plans = PaidUp::Plan.subscribable
    end
  end
end