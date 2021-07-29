class GamesController < ApplicationController
  def index
    games = Game.where(state: 'pending')
    render json: games.to_json(methods: :player_count)
  end

  def show
    game = params_game

    opts = { include: { players: { only: %i[name id is_ai] } } }
    if game.state == 'active'
      opts[:methods] = %i[turn_player_id open_card]
      opts[:include][:players][:methods] = :hand_size
    end
    render json: game.to_json(opts)
  end

  def player_count
    render json: params_game.to_json(only: [], methods: :player_count)
  end

  private

  def params_game
    Game.find(params[:id])
  end
end
