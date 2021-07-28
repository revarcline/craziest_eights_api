Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'page#index'
  get '/games', to: 'games#index'
  get '/games/:id', to: 'games#show'
  get '/games/:id/player_count', to: 'games#player_count'
  get '/games/:id/current_turn', to: 'games#current_turn'
end
