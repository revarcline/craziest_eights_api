Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'page#index'
  get '/games', to: 'games#index'
  get '/games/:id', to: 'games#show'
  get '/games/:id/start', to: 'games#start'
  get '/games/:id/player_count', to: 'games#player_count'
  get '/games/:id/current_turn', to: 'games#current_turn'
  post '/games/:id/new_player', to: 'games#new_player'
  post '/games/:id/end', to: 'games#end'
  delete '/games/:id', to: 'games#destroy'
  get '/players/:id', to: 'players#show'
  post '/players/:id/draw', to: 'players#draw'
  post '/players/:id/play', to: 'players#play'
end
