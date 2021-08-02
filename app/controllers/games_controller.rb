class GamesController < ApplicationController
  before_action :check_authorization, except: %i[index create new_player]

  def index
    @games = Game.where(state: 'pending')
    render 'index'
  end

  def show
    @game = game_from_id
    render 'show'
  end

  def create
    if (@game = Game.create(name: params[:game][:name]) &&
      @player = @game.add_player(params[:player][:name], params[:player][:is_ai]))
      render 'new_player' if @player
    else
      render json: { error: 'could not create game' }
    end
  end

  def start
    game = game_from_id
    if game.start_game
      render 'show'
    else
      render json: { error: 'cannot start game' }
    end
  end

  def new_player
    # this might be tricky? we'll have to see
    @game = game_from_id
    @player = @game.add_player(params[:player][:name], params[:player][:is_ai])
    if @player
      render 'new_player'
    else
      render json: { error: 'could not create new player' }
    end
  end

  def finish
    game = game_from_id
    if game.finish_game
      render json: game_info
    else
      render json: { error: 'cannot finish game' }
    end
  end

  def destroy
    if game_from_id&.state != 'active'
      Game.destroy(params[:game_id])
      render json: { message: "game #{params[:id]} deleted" }
    else
      render json: { error: "no destroyable game with id: #{params[:id]}" }
    end
  end

  private

  def game_from_id
    Game.find(params[:game_id])
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

  def check_authorization
    game = game_from_id
    player = Player.find(params[:player_id])
    player.in?(game.players) && player.valid_token?(params[:auth_token])
  end
end
