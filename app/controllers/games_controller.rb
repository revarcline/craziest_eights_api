class GamesController < ApplicationController
  def index
    games = Game.where(state: 'pending')
    render json: games.to_json(methods: :player_count)
  end

  def show
    game = params_game

    opts = { include: { players: { only: %i[name id is_ai] } } }
    opts[:include][:players][:methods] = :hand_size if game.state == 'active'
    render json: game.to_json(opts)
  end

  def player_count
    render json: params_game.to_json(only: [], methods: :player_count)
  end

  def current_turn
    render json: params_game.to_json(only: [], methods: :turn_player_id)
  end

  private

  def params_game
    Game.find(params[:id])
  end
end
