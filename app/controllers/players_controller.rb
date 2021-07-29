class PlayersController < ApplicationController
  def show
    player = Player.find(params[:id])
    render json: player.to_json(methods: :hand)
  end
end
