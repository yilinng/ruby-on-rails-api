Rails.application.routes.draw do
  resources :notes
  get "/notelist", to: "notes#notelist"
  
  resource :users, only: [:create]
  post "/login", to: "users#login"
  get "/auto_login", to: "users#auto_login"
  delete "/logout", to: "users#destroy"
  get "/userlist", to: "users#index"
end