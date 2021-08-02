Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'page#index'
  get '/games', to: 'games#index'
  get '/games/:game_id/player/:player_id/:token', to: 'games#show'
  post '/games', to: 'games#create'
  post '/games/:game_id/new_player', to: 'games#new_player'
  post '/games/:game_id/start/player/:player_id/:token', to: 'games#start'
  post '/games/:game_id/finish/player/:player_id/:token', to: 'games#finish'
  delete '/games/:game_id/player/:player_id/:token', to: 'games#destroy'
  get '/players/:id/:token', to: 'players#show'
  post '/players/:id/draw/:token', to: 'players#draw'
  post '/players/:id/play/:token', to: 'players#play'
end
