class Player

  attr_reader :username, :secret_number, :guesses, :results

  def initialize(username = 'Player')
    @username = username
    @guesses = Array.new
    @results = Array.new
  end

  def set_secret_number(number)
    @secret_number = number
  end

  def add_guess(number)
    guesses << number
  end

  def add_result(result)
    results << result
  end

end
