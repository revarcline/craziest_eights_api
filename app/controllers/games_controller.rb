class GamesController < ApplicationController
  def index
    games = Game.where(state: 'pending')
    render json: games.to_json(methods: :player_count, except: %i[turn winner])
  end

  def show
    render json: game_info
  end

  def start
    game = game_from_id
    game.start
    render json: game_info
  end

  def new_player
    # this might be tricky? we'll have to see
    game = game_from_id
    game.add_player(params[:player][:name], params[:player][:is_ai])
    render json: game_info
  end

  def finish
    game = game_from_id
    game.finish
    render json: game_info
  end

  def destroy
    Game.destroy(params[:id])
    render json: { message: "game #{params[:id]} deleted." }
  end

  private

  def game_from_id
    Game.find(params[:id])
  end

  def game_info
    game = game_from_id
    opts = { include: { players: { only: %i[name id is_ai] } } }

    if game.state == 'active'
      opts[:methods] = %i[turn_player_id open_card]
      opts[:include][:players][:methods] = :hand_size
    end

    game.to_json(opts)
  end
end
