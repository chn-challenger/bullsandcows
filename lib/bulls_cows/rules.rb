module Rules

  def compare_choices(player_choice, opponent_secret_number)
    result = { bulls: 0, cows: 0 }
    player = convert_to_array(player_choice)
    opponent = convert_to_array(opponent_secret_number)

    player.each.with_index do |number, index|
      result[:bulls] += 1  if bulls?(number, opponent[index])
      result[:cows] += 1   if opponent.include?(number) && !bulls?(number, opponent[index])
    end

    result
  end

  private

  def convert_to_array(number)
    number.to_s.chars
  end

  def bulls?(number1, number2)
    number1 == number2
  end

end
