class PlayersController < ApplicationController
  def show
    render json: player_info
  end

  def play
    player = player_from_id
    card = Card.find(params[:card])
    player.play_card(card)
    render json: player_info
  end

  def draw
    player = player_from_id
    player.draw_from_stock
    render json: player_info
  end

  private

  def player_from_id
    Player.find(params[:id])
  end

  def player_info
    player = player_from_id
    opts = {}
    case player.game.state
    when 'active'
      opts[:methods] = :hand
    when 'complete'
      opts[:methods] = :won?
    end
    player.to_json(opts)
  end
end
