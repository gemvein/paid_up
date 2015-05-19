Rails.application.routes.draw do
  mount PaidUp::Engine => '/', :as => 'paid_up'
  devise_for :users
end
