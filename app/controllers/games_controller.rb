class GamesController < ApplicationController
  protect_from_forgery except: :challenge

  def homepage
  end

  def index
    setup_invites
  end

  def challenge
    $invites[params[:challengee]] = current_user.user_name
    redirect_to '/games/index'
  end

  def accept_challenge
    redirect_to '/games/secret'
  end

  def secret
  end

  private

  def setup_invites
    $invites ||= {}
  end
end
