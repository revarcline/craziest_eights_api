class PlayersController < ApplicationController
  def show
    player = Player.find(params[:id])
    opts = {}
    opts[:methods] = :hand if player.game.state == 'active'
    render json: player.to_json(opts)
  end
end
