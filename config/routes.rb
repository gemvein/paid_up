PaidUp::Engine.routes.draw do
  resources :plans, only: :index do
    get :subscribe, on: :member
  end
end
