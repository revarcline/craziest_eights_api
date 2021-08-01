class ApplicationController < ActionController::API
  def check_authorization(player_id)
    player = Player.find(player_id)
    player&.auth_token == request.headers['Authorization']
  end
end
