class PlayersController < ApplicationController
  before_action :check_authorization

  def show
    @player = player_from_id
    render 'show'
  end

  def play
    @player = player_from_id
    card = Card.find(params[:card])
    if player.play_card(card)
      render 'show'
    else
      render json: { error: 'must make a valid move' }
    end
  end

  def draw
    @player = player_from_id
    if player.draw_from_stock.instance_of?(Card)
      render json: 'show'
    else
      render json: { error: 'could not draw card' }
    end
  end

  private

  def player_from_id
    Player.find(params[:id])
  end

  def check_authorization
    player = player_from_id
    player.valid_token?(request.headers['Authorization'])
  end
end
