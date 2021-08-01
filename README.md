# Crazy Eights API

## Routes
* `get '/games'`: Index all pending games
* `get '/games/:game_id/player/:player_id'`, to: 'games#show'
post '/games', to: 'games#create'
post '/games/:game_id/new_player', to: 'games#new_player'
post '/games/:game_id/start/player/:player_id', to: 'games#start'
post '/games/:game_id/finish/player/:player_id', to: 'games#finish'
delete '/games/:game_id/player/:player_id', to: 'games#destroy'
get '/players/:player_id', to: 'players#show'
post '/players/:id/draw', to: 'players#draw'
post '/players/:id/play', to: 'players#play'

All authenticated routes require an `auth_token` parameter at the root level. This token is automatically generated whenever a new player is created.
