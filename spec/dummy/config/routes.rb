Rails.application.routes.draw do
  
  
  
  mount PaidUp::Engine => '/paid_up', :as => 'PaidUp'
  mount PaidUp::Engine, at: '/'
  devise_for :users
  root to: "home#index"
  
end
