class Player

  attr_reader :username, :secret_number

  def initialize(username = 'Player')
    @username = username
  end

  def set_secret_number(number)
    @secret_number = number
  end

end
