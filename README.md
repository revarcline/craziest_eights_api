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

The lack of a more secure authorization process is *deliberate*: these are throwaway games and player objects, and I wanted to collect as little information from the client as possible while keeping the API easy to use.

All games that have not been interacted with for over 6 hours are wiped from the server at midnight (0:00) UTC with the rake task `clear_idle`.

### Games

Games have three states: `pending`, `active`, and `complete`.

Players can only be added to a game during the `pending` state, up to a maximum of 8. The `pending` state is intended for creating a multiplayer lobby if used with a frontend. The game can be cancelled with the delete action. Only `pending` games can be seen in the index.

In the `active` state, the game tracks the number of turns and which player's turn is currently pending. When a game is set to `active`, the deck is created and cards are dealt to each player. If the discard pile empties, the server will automatically reshuffle it, move its contents to the stock, and move the top card to the discard pile. Active games remain so until a winner is determined or a client deliberately ends the game.

In the `complete` state, the game no longer has a deck, and the winner ID is displayed. The game can now be safely deleted.

`get '/games'`: Index all pending games.
  * example response:
```json
[
  {
    "id": 179,
    "name": "A fun game",
    "player_count": 1,
    "created_at": "2021-08-01T23:12:49.416Z",
    "updated_at": "2021-08-01T23:12:52.317Z"
  },
  ...
]
```

`get '/games/:game_id/player/:player_id/:token'`: Show game details. Authenticated route.
  * example responses for pending, active, and complete games:
```json
{
  "id": 272,
  "name": "Pending Game",
  "state": "pending",
  "created_at": "2021-08-02T02:15:42.343Z","updated_at":"2021-08-02T02:15:42.343Z","players":[{"id":288,"name":"alex","is_ai":false,"hand_size":0}]}
```

```json
{"id":272,"name":"testing win","state":"active","created_at":"2021-08-02T02:15:42.343Z","updated_at":"2021-08-02T02:18:29.394Z","turn":0,"current_player":288,"stock_count":41,"discard_count":1,"open_card":{"id":432,"rank":"4","suit":"D","deck_id":9,"pile_id":33,"created_at":"2021-08-02T02:18:29.201Z","updated_at":"2021-08-02T02:18:29.332Z"},"players":[{"id":288,"name":"alex","is_ai":false,"hand_size":5},{"id":289,"name":"George","is_ai":true,"hand_size":5}]}

```

```json
{
  "id": 272,
  "name": "Won Game",
  "state": "complete",
  "created_at": "2021-08-02T02:15:42.343Z",
  "updated_at": "2021-08-02T02:22:22.179Z",
  "winner": 288,
  "players": [
    {
      "id": 288,
      "name": "alex",
      "is_ai": false,
      "hand_size": 0
    },
    ...
  ]
}
```

`post '/games'`: Create new game and player.
  * example request body:
```json
{
  "game": {
    "name": "testing win"
  },
  "player": {
    "name": "alex",
    "is_ai": false
  }
}
```
  * example response:
```json
{"game":{"id":272,"name":"testing win","state":"pending","created_at":"2021-08-02T02:15:42.343Z","updated_at":"2021-08-02T02:15:42.343Z","players":[{"id":288,"name":"alex","is_ai":false,"hand_size":0}]},"player":{"id":288,"name":"alex","is_ai":false,"created_at":"2021-08-02T02:15:42.347Z","updated_at":"2021-08-02T02:15:42.347Z","auth_token":"xfPXKuyvNU5hqRShxU6usKFM"}}

```

`post '/games/:game_id/new_player'`: Create new player for game if game state is `'pending'`. If `is_ai` is set to true, the response will not contain an `auth_token`, as the player will play automatically.
  * example request body: 
```json
{
  "player": {
    "name": "robot",
    "is_ai": true
  }
}
```
  * example response:
```json
{"id":2,"name":"test","state":"active","created_at":"2021-08-02T03:48:31.017Z","updated_at":"2021-08-02T03:50:07.017Z","turn":0,"current_player":2,"stock_count":41,"discard_count":1,"open_card":{"id":20,"suit":"D","rank":"8"},"players":[{"id":2,"name":"alex","is_ai":false,"hand_size":5},{"id":3,"name":"robot","is_ai":true,"hand_size":5}]}

```

`post '/games/:game_id/start/player/:player_id/:token'`: Set game to `'active'` and deal cards. Authenticated route.
  * example request body: `{}`
  * example response: same as `active` example from `get '/games/:game_id/player/:player_id/:token'`

`post '/games/:game_id/finish/player/:player_id/:token'`: Set game to `'complete'`, whether or not a winner exists. Authenticated route.
  * example request body: `{}`
  * example response: same as `completed` example from `get '/games/:game_id/player/:player_id/:token'`

`delete '/games/:game_id/player/:player_id/:token'`: Destroy game if state is not `'active'`. Authenticated route.
  * response: `{ "message": "game 273 deleted" }`

### Players

All Player routes require authentication, and are **only available during active games**. These routes rely on the existence of a deck, which is created at game start and is destroyed when the game ends.

`get '/players/:player_id/:token'`: Show all player information. 
  * example response:
```json
{
"id": 281,
"name": "Alex",
"my_turn": true,
"won": false,
"created_at": "2021-08-02T01:09:44.001Z",
"updated_at": "2021-08-02T01:09:44.001Z",
"hand": [
    {
      "id": 400,
      "suit": "C",
      "rank": "J"
    }
    ...
  ]
}
```

`post '/players/:id/draw/:token'`, to: 'players#draw'
  * example request body: `{"card": "276"}`
  * example response: same as `get 'players/:player_id/:token'`

`post '/players/:id/play/:token'`, to: 'players#play'
  * example request body: `{}`
  * response: same as `get 'players/:player_id/:token'` unless playing the winning move, which will return:
```json
{
  "id": 288,
  "name": "Winner",
  "my_turn": true,
  "won": 288,
  "created_at": "2021-08-02T02:15:42.347Z",
  "updated_at": "2021-08-02T02:15:42.347Z",
  "hand": []
}

```
