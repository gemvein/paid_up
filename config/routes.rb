PaidUp::Engine.routes.draw do
  resources :plans, only: :index
end
