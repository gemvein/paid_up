Rails.application.routes.draw do
  
  
  
  mount SubscriptionFeatures::Engine => '/subscription_features', :as => 'SubscriptionFeatures'
  mount SubscriptionFeatures::Engine, at: '/'
  devise_for :users
  root to: "home#index"
  
end
