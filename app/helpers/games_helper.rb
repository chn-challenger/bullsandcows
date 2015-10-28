module GamesHelper
  def setup_users
    $users ||= Array.new
  end

  def setup_invites
    $invites ||= Hash.new
  end

  def new_visitor?
    $users.include?(current_user.user_name) == false
  end

  def player_1?
    current_user.user_name == $game.player_1.username
  end

  def player_2?
    current_user.user_name == $game.player_2.username
  end

  def current_user_turn?
    $game.turn.username == current_user.user_name
  end

  def winner?
    @result.values[0] == 4
  end
end
