Rails.application.routes.draw do
  post '/visit_comments', to: 'visit_comments#create'
  post '/visit_comments/:id', to: 'visit_comments#update'
  get '/appartments/analysis', to: 'appartments#index_analysis'
  get '/appartments/map', to: 'appartments#index_map'
  post '/appartments/:id', to: 'appartments#update'
  resources :appartments
  resources :filters

  get '/', to: 'appartments#home'
  get '/auth', to: 'appartments#auth'
end