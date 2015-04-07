Rails.application.routes.draw do

  mount PaidUp::Engine => '/', :as => 'PaidUp'
  devise_for :users
  
end
