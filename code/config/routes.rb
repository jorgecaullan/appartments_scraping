Rails.application.routes.draw do
  post '/visit_comments', to: 'visit_comments#create'
  post '/visit_comments/:id', to: 'visit_comments#update'
  
  get '/appartments/analysis', to: 'appartments#index_analysis'
  get '/appartments/liked', to: 'appartments#index_liked'
  get '/appartments/rejected', to: 'appartments#index_rejected'
  get '/appartments/sold', to: 'appartments#index_sold'

  get '/appartments/analysis/map', to: 'appartments#index_map_analysis'
  get '/appartments/liked/map', to: 'appartments#index_map_liked'
  get '/appartments/rejected/map', to: 'appartments#index_map_rejected'
  get '/appartments/sold/map', to: 'appartments#index_map_sold'

  post '/appartments/:id', to: 'appartments#update'
  resources :appartments
  resources :filters

  get '/', to: 'appartments#home'
  get '/auth', to: 'appartments#auth'
end