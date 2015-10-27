require "./lib/bulls_cows/player"

describe Player do

    context "at the start" do

      it "initialize with a default name when not provided one" do
        expect(subject.username).to eq "Player"
      end

      it "initialize with a name provided" do
        player = Player.new('Zhivko')
        expect(player.username).to eq "Zhivko"
      end

    end

    context "player methods" do

      let(:number) { number = 1234 }

      it "#set_secret_number" do
        subject.set_secret_number(number)
        expect(subject.secret_number).to eq number
      end

    end

end
