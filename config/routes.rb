PaidUp::Engine.routes.draw do
  resources :plans, only: :index do
    resources :subscriptions, only: :new
  end
end
