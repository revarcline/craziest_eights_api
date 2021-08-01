Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'page#index'
  get '/games', to: 'games#index'
  get '/games/:game_id/player/:player_id', to: 'games#show'
  post '/games', to: 'games#create'
  post '/games/:game_id/new_player', to: 'games#new_player'
  post '/games/:game_id/start/player/:player_id', to: 'games#start'
  post '/games/:game_id/finish/player/:player_id', to: 'games#finish'
  delete '/games/:game_id/player/:player_id', to: 'games#destroy'
  get '/players/:player_id', to: 'players#show'
  post '/players/:id/draw', to: 'players#draw'
  post '/players/:id/play', to: 'players#play'
end
