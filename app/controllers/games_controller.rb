class GamesController < ApplicationController
  def index
    games = Game.where(state: 'pending')
    render json: games.to_json(methods: :player_count, except: %i[turn winner])
  end

  def show
    render json: game_info
  end

  def create
    game = Game.create(name: params[:game][:name])
    if game.id_in_database && game.add_player(params[:player][:name], params[:player][:is_ai])
      render json: game.to_json(include: :players)
    else
      render json: { error: 'could not create game' }
    end
  end

  def start
    game = game_from_id
    if game.start_game
      render json: game_info
    else
      render json: { error: 'cannot start game' }
    end
  end

  def new_player
    # this might be tricky? we'll have to see
    game = game_from_id
    if game.add_player(params[:player][:name], params[:player][:is_ai])
      render json: game_info
    else
      render json: { error: 'could not create new player' }
    end
  end

  def finish
    game = game_from_id
    game.finish
    render json: game_info
  end

  def destroy
    if game_from_id
      Game.destroy(params[:id])
      render json: { message: "game #{params[:id]} deleted" }
    else
      render json: { error: "no game with id #{params[:id]}" }
    end
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
