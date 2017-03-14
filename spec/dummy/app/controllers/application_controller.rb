class ApplicationController < ActionController::Base
  helper PaidUp::PaidUpHelper
  protect_from_forgery
end
