class GamesController < ApplicationController
  def index
    games = Game.where(state: 'pending')
    render json: games.to_json(methods: :player_count)
  end
end
