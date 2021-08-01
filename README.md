# Crazy Eights API

## Example Deploy
An example deployment is available 

## Routes, Requests, and Responses
There are two primary controllers for `craziest-eights`, `games` and `players`.

All authenticated routes require an `auth_token` parameter at the root level. This token is automatically generated when a new player is created. It is only returned once, in the responses to `post /games` and `post /games/:game_id/new_player`, and must be saved by the user or client. For SPAs and other clients, a good option is to keep it in the browser's `localStorage` along with `player_id` and `game_id`.

All games that have not been interacted with for over 6 hours are wiped from the server at midnight (0:00) UTC.

####Games
* `get '/games'`: Index all pending games.
* `get '/games/:game_id/player/:player_id'`: Show game details. Authenticated route.
* `post '/games'`: Create new game and player.
* `post '/games/:game_id/new_player'`: Create new player for game if game state is `'pending'`.
* `post '/games/:game_id/start/player/:player_id'`: Set game to `'active'` and deal cards. Authenticated route.
* `post '/games/:game_id/finish/player/:player_id'`: Set game to `'complete'`, whether or not a winner exists. Authenticated route.
* `delete '/games/:game_id/player/:player_id'`: Destroy game if state is not `'active'`. Authenticated route.

####Players
* `get '/players/:player_id'`: 
post '/players/:id/draw', to: 'players#draw'
post '/players/:id/play', to: 'players#play'

## Sample API library
An example of an API libarary using JavaScript `fetch` calls is available at `/sample/userApi.js`. It is currently pointing to the example deployment at `https://craziest-eights.buckar.ooo` but the `API_ROOT` constant can be changed for local usage.
