class PaidUp::PlansController < ApplicationController
  def index
    @plans = PaidUp::Plan.all
  end
end