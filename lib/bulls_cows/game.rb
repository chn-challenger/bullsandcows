require "./lib/bulls_cows/rules"

class Game

  include Rules

  attr_reader :player_1, :player_2, :turn, :winner

  def initialize(player_1, player_2)
    @player_1, @player_2, @turn = player_1, player_2, player_1
  end

  def make_move(number)
    result = compare_choices(number, opponent.secret_number)
    @winner = turn.username if result[:bulls] == 4
    turn.add_guess(number)
    turn.add_result(result)
    switch_turns
    result
  end

  def opponent
    turn == player_1 ? player_2 : player_1
  end

  private

  def switch_turns
    @turn = opponent
  end

end
