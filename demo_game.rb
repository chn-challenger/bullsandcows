Dir["./lib/bulls_cows/*.rb"].each {|file| require file}

player1 = Player.new("Zhivko")
player2 = Player.new("Joe")
player1.set_secret_number(1234)
player2.set_secret_number(5678)
game = Game.new(player1,player2)
p game.turn
p game.make_move(5679)
p game.turn
p game.make_move(5679)
