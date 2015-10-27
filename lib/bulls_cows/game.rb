require "./lib/bulls_cows/rules"

class Game

  include Rules

  attr_reader :player_1, :player_2, :turn

  def initialize(player_1, player_2)
    @player_1, @player_2, @turn = player_1, player_2, player_1
  end

  def make_move(number)
    turn.add_guess(number)
    result = compare_choices(number,opponent.secret_number)
    switch_turns
    result
  end

  private

  def switch_turns
    @turn = opponent
  end

  def opponent
    turn == player_1 ? player_2 : player_1
  end

end
