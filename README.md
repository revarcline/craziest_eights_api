# Crazest Eights API

`craziest-eights` is a Rails API simulating a game of Crazy Eights with human and/or AI players.

## Rules of Play
* A game is created, along with the first player.
* Players can join or AI players can be added (up to 8 players total) until play starts.
* Players are dealt five cards, and play in order of joining.
* One card is removed from the stock pile and placed facing up, starting the discard pile.
* On a player's turn, they can play any card in their hand that matches either the suit or the rank of the open card on the discard pile. 8s are wild.
* When an 8 is played, the next player must match its suit or play another 8.
* If there are no matches in the player's hand, they can draw from the stock until a match is found.
* Play continues until a player plays their enire hand, at which point they win.

## Example Deploy
An example deployment is available [here](https://craziest-eights.herokuapp.com). Because tokens are used in the URL, deploying with SSL is highly recommended.

## Sample API library
An example of an API libarary using JavaScript `fetch` calls is available at `/sample/userApi.js`. It is currently pointing to the example deployment at `https://craziest-eights.herokuapp.com` but the `API_ROOT` constant can be changed for local usage.

## AI player
If deploying with a frontend, it might be desirable to uncomment line 15 of `app/models/player.rb` to add a 2.5 second latency to ai player moves. On the current deploy, AI players move instantly.

## Routes, Requests, and Responses
There are two primary controllers for `craziest-eights`, `games` and `players`.

All authenticated routes require an `auth_token` as the final parameter in the URL. This token is automatically generated when a new player is created. It is only returned once, in the responses to `post /games` and `post /games/:game_id/new_player`, and must be saved by the user or client. For SPAs and other clients, a good option is to keep it in the browser's `localStorage` along with `player_id` and `game_id`.

The lack of a more secure authorization process is deliberate: these are throwaway games and player objects.

All games that have not been interacted with for over 6 hours are wiped from the server at midnight (0:00) UTC with the rake task `clear_idle`.

### Games
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
    ```json
    ```

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

### Players
`get '/players/:player_id/:token'`: Show all player information. 
  * response:
```json
{
"id":281,
"name":"Alex",
"my_turn":true,
"won":false,
"created_at":"2021-08-02T01:09:44.001Z",
"updated_at":"2021-08-02T01:09:44.001Z",
"hand":
  [
    {
      "id":400,
      "suit":"C",
      "rank":"J"
    }
    ...
  ]
}
```

`post '/players/:id/draw/:token'`, to: 'players#draw'
  * request body: {}
`post '/players/:id/play/:token'`, to: 'players#play'
  * request body: {}
