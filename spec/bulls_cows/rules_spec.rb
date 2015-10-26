require './lib/bulls_cows/rules'

describe Rules do

  context '#compare_choices' do

    it 'have 4 bulls' do
      result = { bulls: 4, cows: 0 }
      expect(subject.compare_choices(1234, 1234)).to eq result
    end

    it 'have 4 cows' do
      result = { bulls: 0, cows: 4 }
      expect(subject.compare_choices(1234, 4321)).to eq result
    end

    it 'have no bulls and no cows' do
      result = { bulls: 0, cows: 0 }
      expect(subject.compare_choices(1234, 9876)).to eq result
    end

    it 'have 2 bulls and 2 cows' do
      result = { bulls: 2, cows: 2 }
      expect(subject.compare_choices(1234, 1243)).to eq result
    end

    it 'have 3 bulls and no cows' do
      result = { bulls: 3, cows: 0 }
      expect(subject.compare_choices(1234, 1235)).to eq result
    end

  end

end
