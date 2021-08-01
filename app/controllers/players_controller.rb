class PlayersController < ApplicationController
  before_action :check_authorization

  def show
    render json: player_info
  end

  def play
    player = player_from_id
    card = Card.find(params[:card])
    if player.play_card(card)
      render json: player_info
    else
      render json: { error: 'must make a valid move' }
    end
  end

  def draw
    player = player_from_id
    if player.draw_from_stock.instance_of?(Card)
      render json: player_info
    else
      render json: { error: 'could not draw card' }
    end
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

  def check_authorization
    player = player_from_id
    player.valid_token?(request.headers['Authorization'])
  end
end
