require './lib/bulls_cows/player'
require './lib/bulls_cows/game'

class GamesController < ApplicationController
  protect_from_forgery except: [:challenge, :save_secret]

  def homepage
  end

  def index
    setup_invites
    redirect_to '/games/set_secret' if $game != nil
  end

  def challenge
    $invites[params[:challengee]] = current_user.user_name
    redirect_to '/games/index'
  end

  def accept_challenge
    player_1 = Player.new $invites[current_user.user_name]
    player_2 = Player.new current_user.user_name
    $game = Game.new player_1, player_2
    redirect_to '/games/set_secret'
  end

  def set_secret
  end

  def save_secret
    if current_user.user_name == $game.player_1.username
      $game.player_1.set_secret_number params[:key]
    else
      $game.player_2.set_secret_number params[:key]
    end
    redirect_to '/games/new'
  end

  def new
  end

  def guess
    @result = $game.make_move params[:guess]
    @turn = $game.turn
    redirect_to '/games/new'
  end

  private

  def setup_invites
    $invites ||= {}
  end
end
