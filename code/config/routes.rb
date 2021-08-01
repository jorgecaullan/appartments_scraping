Rails.application.routes.draw do
  resources :visit_comments
  resources :appartments
  resources :filters

  get '/', to: 'appartments#home'
  get '/auth', to: 'appartments#auth'
end