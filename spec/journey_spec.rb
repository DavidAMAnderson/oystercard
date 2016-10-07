require 'journey'
require 'oystercard'

describe Journey do

  let(:station_z1){ double :station, zone: 1 }
  let(:station_z2){ double :station, zone: 2 }
  let(:station_z3){ double :station, zone: 3 }

  describe '#initialize' do

    it 'has a default entry_station of nil' do
      expect(subject.entry_station).to eq nil
    end
  end

  describe '#complete?' do
    it "knows if a journey is not complete" do
      expect(subject).not_to be_complete
    end
  end

  context 'given an entry station' do

    subject {described_class.new(entry_station = "station")}

    it 'has an entry station' do
      expect(subject.entry_station).to eq "station"
    end
  end

  context 'given an exit station' do
    before do
      described_class.new(entry_station = "station")
      subject.end("other_station")
    end

    it "knows if a journey is complete" do
      expect(subject).to be_complete
    end
  end

  describe '#fare' do

    it 'charges PENALTY_FARE for not touching out of previous trip' do
      described_class.new(entry_station = "station")
      expect(subject.fare).to eq(Journey::PENALTY_FARE)
    end

    it 'charges PENALTY_FARE for not touching in' do
      described_class.new
      expect(subject.fare).to eq(Journey::PENALTY_FARE)
    end

    it 'charges £1 for zone 1 to zone 1 journey' do
      test_journey = described_class.new(station_z1)
      test_journey.end(station_z1)
      expect(test_journey.fare).to eq(1)
    end

    it 'charges £2 for zone 2 to zone 3 journey' do
      test_journey = described_class.new(station_z2)
      test_journey.end(station_z3)
      expect(test_journey.fare).to eq(2)
    end

    it 'charges £3 for zone 3 to zone 1 journey' do
      test_journey = described_class.new(station_z3)
      test_journey.end(station_z1)
      expect(test_journey.fare).to eq(3)
    end

  end
end
