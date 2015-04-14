module PaidUp
  class PlansController < PaidUpController
    def index
      @plans = PaidUp::Plan.all
    end
  end
end