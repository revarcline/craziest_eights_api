const ROOT_URL = "http://localhost:3000";

const jsonHeaders = {
  headers: {
    Accept: "application/json",
    "Content-type": "application/json; charset=UTF-8",
  },
};

const postOpts = { ...jsonHeaders, method: "POST" };

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

    create: (name, playerName) =>
      fetch(`${ROOT_URL}/games`, {
        ...postOpts,
        body: JSON.stringify({
          game: {
            name: name,
          },
          player: {
            name: playerName,
            is_ai: false,
          },
        }),
      }).then((response) => response.json()),

    // player obj: {name: string, is_ai: boolean}
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

    destroy: (game, player) =>
      fetch(`${ROOT_URL}/games/${game}/player/${player}`, {
        ...jsonHeaders,
        method: "DELETE",
      }).then((response) => response.json()),
  },

  player: {
    show: (player) =>
      fetch(`${ROOT_URL}/players/${player}`, {
        ...jsonHeaders,
      }).then((response) => response.json()),

    drawCard: (player) =>
      fetch(`${ROOT_URL}/players/${player}/draw`, {
        ...postOpts,
        body: JSON.stringify({}),
      }).then((response) => response.json()),

    playCard: (player, card) =>
      fetch(`${ROOT_URL}/players/${player}/play`, {
        ...postOpts,
        body: JSON.stringify({ card: card }),
      }).then((response) => response.json()),
  },
};

// examples of keeping client details in localStorage on player join

export default userApi;
