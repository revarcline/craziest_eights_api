class PlayersController < ApplicationController
  def show
    player_info
  end

  private

  def params_player
    Player.find(params[:id])
  end

  def player_info
    player = params_player
    opts = {}
    case player.game.state
    when 'active'
      opts[:methods] = :hand
    when 'complete'
      opts[:methods] = won?
    end
    render json: player.to_json(opts)
  end
end
