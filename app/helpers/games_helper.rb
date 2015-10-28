module GamesHelper
  def setup_users
    $users ||= Array.new
  end

  def setup_invites
    $invites ||= Hash.new
  end

  def new_visitor?
    $users.include? current_user.user_name == false
  end

  def current_user_turn?
    $game.turn.username == current_user.user_name
  end
end
