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
    session[:challengee] = params[:challengee]
    redirect_to '/games/index'
    @user = User.find_by(user_name: params[:challengee])
    Pusher.trigger("user_#{@user.user_name}_channel", 'challenge', {challenger: current_user.user_name, challengee: params[:challengee]})
  end

  def waiting
    @challengee = session[:challengee]
  end

  def accept_challenge
    record = Bullsandcowsgame.new
    game = Game.new(Player.new(params[:challenger]),Player.new(params[:challengee]))
    record.state = game
    record.save
    @game_id = record.id
    redirect_to "/games/set_secret?game_id=#{@game_id}"
    Pusher.trigger("user_#{params[:challenger]}_channel", 'secret', {game_id: @game_id})
  end

  def set_secret
    #on this page with the box to set secret
    # if $game.player_1.username == current_user.user_name
    #   @user_secret = $game.player_1.secret_number
    # end
    # if $game.player_2.username == current_user.user_name
    #   @user_secret = $game.player_2.secret_number
    # end
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

    @ready = true

    redirect_to '/games/set_secret'
    # if current_game.player_1.secret_number && current_game.player_2.secret_number
    #   Pusher.trigger("to_game", 'start_game', {})
    #   # redirect_to '/games/new'
    # else
    #   redirect_to '/games/set_secret'
    # end
    # redirect_to '/games/new'
  end

  def new
  end

  def guess
    @result = $game.make_move params[:guess]
    if winner?
      Pusher.trigger('game', 'end_game', {})
    else
      Pusher.trigger('game', 'play_game', {})
    end
  end

  def end
    $loaded ||= 0
    if current_user.user_name == $game.winner
      $loaded += 1
      @message = "Congratulations you have won!"
    else
      @message = "Bad luck, you have lost!"
      $loaded += 1
    end
    if $loaded >= 2
      $game = nil
      $users = []
      $invites = {}
      $loaded = 0
    end
  end

  def accept

  end

  def test
    @view = params[:name]
    # Lobbyuser.create(username: "joe123")
    # Lobbyuser.create(username: "helloworld")
    # @view = Lobbyuser.find(1).username
    # @user = Lobbyuser.find_by username: 'Joe123'

    # @class = @view.class
    # test1 = Bullsandcowsgame.new
    # game = Game.new(Player.new('Joe'),Player.new('Jongmin'))
    # game.player_1.set_secret_number 1234
    # test1.state = game
    # test1.save

    # current_game = Bullsandcowsgame.find(1).state
    # @view = current_game.class.to_s
    # current_game.player_1.set_secret_number 1234
    # current_game.player_2.set_secret_number 4567
    # current_game.make_move(4762)
    # current_game.make_move(1236)
    # current_game.make_move(1298)
    # update_game = Bullsandcowsgame.find(1)
    # update_game.state = current_game
    # update_game.save
    # view_game = Bullsandcowsgame.find(1).state
    # @view = Bullsandcowsgame.find(1).state.player_1.results
    # Bullsandcowsgame.find(1).state.player_1.set_secret_number 1234
    # session[:smessage] = "We love Ruby!"
  end

  def test1
    if Lobbyuser.find_by(username: current_user.user_name)
      @view = "YES YES YES"
      # session[:current_users] << current_user.user_name
      # Pusher.trigger("users", 'refresh_users', {})
    end
  end

  def test2
    # @view = session[:smessage]
  end

end
