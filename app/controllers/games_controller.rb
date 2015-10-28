require './lib/bulls_cows/player'
require './lib/bulls_cows/game'

class GamesController < ApplicationController
  include GamesHelper
  protect_from_forgery except: [:challenge, :save_secret, :guess]
  before_action :authenticate_user!, except: [:homepage]

  def homepage
  end

  def index
    setup_invites
    setup_users
    if new_visitor?
      $users << current_user.user_name
      Pusher.trigger("users", 'refresh_users', {})
    end
  end

  def challenge
    $invites[params[:challengee]] = current_user.user_name
    redirect_to '/games/index'
    @user = User.find_by(user_name: params[:challengee])
    Pusher.trigger("user_#{@user.id}_channel", 'challenge', {challenger: current_user, challengee: @user})
  end

  def accept_challenge
    player_1 = Player.new $invites[current_user.user_name]
    player_2 = Player.new current_user.user_name
    $game = Game.new player_1, player_2
    redirect_to '/games/set_secret'
    @user = User.find_by(user_name: player_1.username)
    Pusher.trigger("user_#{@user.id}_channel", 'secret', {})
  end

  def set_secret
    if player_1?
      @user_secret = $game.player_1.secret_number
    end
    if player_2?
      @user_secret = $game.player_2.secret_number
    end
  end

  def save_secret
    if player_1?
      $game.player_1.set_secret_number params[:key]
    else
      $game.player_2.set_secret_number params[:key]
    end
    if $game.player_1.secret_number && $game.player_2.secret_number
      Pusher.trigger("to_game", 'start_game', {})
    else
      redirect_to '/games/set_secret'
    end
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
    setup_loaded
    if current_user.user_name == $game.winner
      $loaded += 1
      @message = "Congratulations you have won!"
    else
      @message = "Bad luck, you have lost!"
      $loaded += 1
    end
    if $loaded >= 2
      $game = nil
      $users = Array.new
      $invites = Hash.new
      $loaded = 0
    end
  end

  def accept
  end
end
