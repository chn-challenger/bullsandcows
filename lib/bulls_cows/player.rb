class Player

  attr_reader :name, :secret_number, :picked_numbers

  def initialize(name = 'Player')
    @name = name
    @picked_numbers = []
  end

  def set_secret_number(number)
    @secret_number = number
  end

  def pick_number(number)
    picked_numbers << number
  end

end
