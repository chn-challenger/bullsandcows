require './lib/bulls_cows/player'
require './lib/bulls_cows/game'

class GamesController < ApplicationController
  include GamesHelper

  protect_from_forgery except: [:challenge, :save_secret]
  skip_before_filter  :verify_authenticity_token
  # before_action :authenticate_user!, except: [:homepage]

  def homepage
  end

  def index
    if Lobbyuser.find_by(username: current_user.user_name)
      @lobbyusers = Lobbyuser.all
    else
      Lobbyuser.create(username: current_user.user_name)
      Pusher.trigger("users", 'refresh_users', {})
    end
  end

  def challenge
    Lobbyuser.find_by(username: current_user.user_name).destroy
    redirect_to '/games/waiting'
    Pusher.trigger("user_#{params[:challengee]}_channel", 'challenge', {challenger: current_user.user_name, challengee: params[:challengee]})
  end

  def waiting
    @challengee = session[:challengee]
  end

  def accept_challenge
    Lobbyuser.find_by(username: current_user.user_name).destroy
    record = Bullsandcowsgame.new
    game = Game.new(Player.new(params[:challenger]),Player.new(params[:challengee]))
    record.state = game
    record.save
    @game_id = record.id
    redirect_to "/games/set_secret?game_id=#{@game_id}"
    Pusher.trigger("user_#{params[:challenger]}_channel", 'secret', {game_id: @game_id})
  end

  def set_secret
    session[:game_id] = params[:game_id] if params[:game_id]
  end

  def save_secret
    record = Bullsandcowsgame.find(params[:game_id])
    current_game = record.state

    if current_game.player_1.username == current_user.user_name
        current_game.player_1.set_secret_number params[:key]
    end
    if current_game.player_2.username == current_user.user_name
        current_game.player_2.set_secret_number params[:key]
    end

    record.state = current_game
    record.save

    if current_game.player_1.secret_number && current_game.player_2.secret_number
      @player1 = current_game.player_1.username
      @player2 = current_game.player_2.username
      Pusher.trigger("#{@player1}", 'start_game', {})
      Pusher.trigger("#{@player2}", 'start_game', {})
    else
      redirect_to '/games/set_secret?ready=true'
    end
  end

  def new
    record = Bullsandcowsgame.find(session[:game_id])
    @game = record.state
  end

  def guess
    record = Bullsandcowsgame.find(session[:game_id])
    current_game = record.state
    @result = current_game.make_move params[:guess]
    record.state = current_game
    record.save
    @player1 = current_game.player_1.username
    @player2 = current_game.player_2.username
    if current_game.winner
      Pusher.trigger("#{@player1}_game", 'end_game', {})
      Pusher.trigger("#{@player2}_game", 'end_game', {})
    else
      Pusher.trigger("#{@player1}_game", 'play', {})
      Pusher.trigger("#{@player2}_game", 'play', {})
    end
  end

  def end
    record = Bullsandcowsgame.find(session[:game_id])
    current_game = record.state
    if current_user.user_name == current_game.winner
      @message = "Congratulations you have won!"
    else
      @message = "Bad luck, you have lost!"
    end
    session[:game_id] = nil
  end


  # def accept
  #
  # end

  # def test
  #   @view = session[:game_id]
  #   end
  #
  # def test1
  #   if Lobbyuser.find_by(username: current_user.user_name)
  #     @view = "YES YES YES"
  #   end
  # end
  #
  # def test2
  #   # @view = session[:smessage]
  # end


end
