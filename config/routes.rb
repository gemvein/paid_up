PaidUp::Engine.routes.draw do
  resources :plans, only: :index do
    member do
      get :subscribe
    end
  end
end
