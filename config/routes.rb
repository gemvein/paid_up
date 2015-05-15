PaidUp::Engine.routes.draw do
  resources :plans, only: :index do
    resources :subscriptions, only: [:new, :create]
  end

  resources :subscriptions, only: [:index]
end
