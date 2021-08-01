# Crazy Eights API

## Example Deploy
An example deployment is available [here](https://craziest-eights.buckar.ooo)


## Sample API library
An example of an API libarary using JavaScript `fetch` calls is available at `/sample/userApi.js`. It is currently pointing to the example deployment at `https://craziest-eights.buckar.ooo` but the `API_ROOT` constant can be changed for local usage.

## AI player
If deploying with a frontend, it might be desirable to uncomment line 15 of `app/models/player.rb` to add a 2.5 second latency to ai player moves. On the current deploy, AI players move instantly.

# Routes, Requests, and Responses
There are two primary controllers for `craziest-eights`, `games` and `players`.

All authenticated routes require an `auth_token` as the final parameter in the URL. This token is automatically generated when a new player is created. It is only returned once, in the responses to `post /games` and `post /games/:game_id/new_player`, and must be saved by the user or client. For SPAs and other clients, a good option is to keep it in the browser's `localStorage` along with `player_id` and `game_id`.

The lack of a more secure authorization process is deliberate: these are throwaway games and player objects.

All games that have not been interacted with for over 6 hours are wiped from the server at midnight (0:00) UTC.

###Games
`get '/games'`: Index all pending games.
  * example response:
  ```json
  [
    {
      "id": "1",
      "name": "A fun game",
      "player_count": "1",
      "created_at": "2021-08-01T23:12:49.416Z",
      "updated_at": "2021-08-01T23:12:52.317Z"
    },
    ...
  ]
  ```

`get '/games/:game_id/player/:player_id/:token'`: Show game details. Authenticated route.
  * example response:

`post '/games'`: Create new game and player.
  * request body:
  * response:
`post '/games/:game_id/new_player'`: Create new player for game if game state is `'pending'`. If `is_ai` is set to true, the response will not contain an `auth_token`, as the player will play automatically.
  * example request body:
`post '/games/:game_id/start/player/:player_id/:token'`: Set game to `'active'` and deal cards. Authenticated route.
  * example request body:
`post '/games/:game_id/finish/player/:player_id/:token'`: Set game to `'complete'`, whether or not a winner exists. Authenticated route.
  * example request body:
`delete '/games/:game_id/player/:player_id/:token'`: Destroy game if state is not `'active'`. Authenticated route.

##Players
`get '/players/:player_id/:token'`: Show all player information. 
  * response:
`post '/players/:id/draw/:token'`, to: 'players#draw'
  * request body: {}
`post '/players/:id/play/:token'`, to: 'players#play'
  * request body: {}
