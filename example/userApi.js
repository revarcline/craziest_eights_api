/* This is a sample javascript api interface for craziest-eights.
 * Everything exported from this file can be called with async () => await
 * syntax, or can be used for testing from the console without the exports. */

// set root url here, currently pointed to example deploy.
// it's currently on free heroku dynos so may take a second to spin up.
const ROOT_URL = "http://craziest-eights.herokuapp.com/";

// basic headers
const jsonHeaders = {
  headers: {
    Accept: "application/json",
    "Content-type": "application/json; charset=UTF-8",
  },
};

// post method
const postOpts = { ...jsonHeaders, method: "POST" };

// all API calls come from this object.
// (e.g. userApi.game.create("game", "player"))
const userApi = {
  game: {
    index: () =>
      fetch(`${ROOT_URL}/games`, {
        ...jsonHeaders,
      }).then((response) => response.json()),

    show: (game, player, token) =>
      fetch(`${ROOT_URL}/games/${game}/player/${player}/${token}`, {
        ...jsonHeaders,
      }).then((response) => response.json()),

    create: (gameName, playerName) =>
      fetch(`${ROOT_URL}/games`, {
        ...postOpts,
        body: JSON.stringify({
          game: {
            name: gameName,
          },
          player: {
            name: playerName,
            is_ai: false,
          },
        }),
      }).then((response) => response.json()),

    // player object: {name: string, is_ai: boolean}
    newPlayer: (game, player) =>
      fetch(`${ROOT_URL}/games/${game}/new_player`, {
        ...postOpts,
        body: JSON.stringify({ player: player }),
      }).then((response) => response.json()),

    start: (game, player, token) =>
      fetch(`${ROOT_URL}/games/${game}/start/player/${player}/${token}`, {
        ...postOpts,
        body: JSON.stringify({}),
      }).then((response) => response.json()),

    finish: (game, player, token) =>
      fetch(`${ROOT_URL}/games/${game}/finish/player/${player}/${token}`, {
        ...postOpts,
        body: JSON.stringify({}),
      }).then((response) => response.json()),

    destroy: (game, player, token) =>
      fetch(`${ROOT_URL}/games/${game}/player/${player}/${token}`, {
        ...jsonHeaders,
        method: "DELETE",
      }).then((response) => response.json()),
  },

  player: {
    show: (player, token) =>
      fetch(`${ROOT_URL}/players/${player}/${token}`, {
        ...jsonHeaders,
      }).then((response) => response.json()),

    drawCard: (player, token) =>
      fetch(`${ROOT_URL}/players/${player}/draw/${token}`, {
        ...postOpts,
        body: JSON.stringify({}),
      }).then((response) => response.json()),

    playCard: (player, card, token) =>
      fetch(`${ROOT_URL}/players/${player}/play/${token}`, {
        ...postOpts,
        body: JSON.stringify({ card: card }),
      }).then((response) => response.json()),
  },
};

/* examples of keeping client details in localStorage on player join */

// helper method
const saveToLocalStorage = (gameInfo) => {
  localStorage.setItem("gameId", gameInfo.game.id);
  localStorage.setItem("playerId", gameInfo.player.id);
  localStorage.setItem("authToken", gameInfo.player.auth_token);
};

// create a new game and store info to localStorage
const newGame = (gameName, playerName) => {
  userApi.game
    .create(gameName, playerName)
    .then((gameInfo) => saveToLocalStorage(gameInfo));
};

// add a new human player and store info to localStorage
const joinGame = (gameId, playerName) => {
  userApi.game
    .newPlayer(gameId, { name: playerName, is_ai: false })
    .then((gameInfo) => saveToLocalStorage(gameInfo));
};

// create an AI player
const addAIPlayer = (gameId, playerName) =>
  userApi.game.newPlayer(gameId, { name: playerName, is_ai: true });

// it's recommended to clear localStorage on the delete action.
// even if the delete gives a 404, each client should run it on game close.
const deleteGame = () =>
  userApi.game
    .destroy(
      localStorage.getItem("gameId"),
      localStorage.getItem("playerId"),
      localStorage.getItem("authToken"),
    )
    .then(() => localStorage.clear());

export default userApi;
export { saveToLocalStorage, newGame, joinGame, addAIPlayer, deleteGame };

/* helpful little bit of code for loading vars from localStorage in console
 
 let gameId = localStorage.getItem("gameId");
 let playerId = localStorage.getItem("playerId");
 let authToken = localStorage.getItem("authToken");

*/
