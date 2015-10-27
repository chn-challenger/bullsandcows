class Player

  attr_reader :username, :secret_number, :guesses

  def initialize(username = 'Player')
    @username = username
    @guesses = []
  end

  def set_secret_number(number)
    @secret_number = number
  end

  def add_guess(number)
    guesses << number
  end

end
