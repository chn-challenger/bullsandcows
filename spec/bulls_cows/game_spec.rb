require './lib/bulls_cows/game'

describe Game do

  let(:player1)  { double(:player1, secret_number: 4321) }
  let(:player2)  { double(:player2, secret_number: 1234) }
  let(:game)     { described_class.new(player1, player2) }
  
  context 'Game starts' do

    context 'has 2 players' do
      it 'has player 1' do
        expect(game.player_1).to eq player1
      end

      it 'has player 2' do
        expect(game.player_2).to eq player2
      end

    end

    context 'Turns' do

      it 'starts with player 1\'s turn' do
        expect(game.turn).to eq player1
      end

      it 'return the result after player 1\'s turn' do
        result = { bulls: 0, cows: 2}
        expect(game.make_move(4356)).to eq result
      end

      it 'return the result after player 2\'s turn' do
        result = { bulls: 2, cows: 0}
        game.make_move(1234)
        expect(game.make_move(4356)).to eq result
      end

      it 'player 2\'s turn after one turn' do
        game.make_move(1234)
        expect(game.turn).to eq player2
      end

      it 'player 1 turn again after player 2 has played' do
        game.make_move(1234)
        game.make_move(3421)
        expect(game.turn).to eq player1
      end

    end

  end

end
