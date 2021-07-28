class GamesController < ApplicationController
  def index
    games = Game.where(state: 'pending')
    render json: games.to_json(methods: :player_count)
  end

  def player_count
    game = Game.find(params[:id])
    render json: game.to_json(only: [], methods: :player_count)
  end

  def current_turn
    game = Game.find(params[:id])
    render json: game.to_json(only: [], methods: :turn_id)
  end
end
