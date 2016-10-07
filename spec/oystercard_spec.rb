require 'oystercard'

describe Oystercard do

  let(:entry_station) {double(:station)}
  let(:exit_station) {double(:station)}
  let(:station_z1){ double :station, zone: 1 }
  let(:journey) {double(:journey)} #{ {entry_station: entry_station, exit_station: exit_station} }

  context 'With max balance on card' do
    before do
      subject.top_up(described_class::MAXIMUM_BALANCE)
    end

    it 'can not be topped up beyond limit' do
      message = "Beyond limit of #{described_class::MAXIMUM_BALANCE}"
      expect{subject.top_up(1)}.to raise_error message
    end
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'can top up the balance' do
      expect{ subject.top_up 1}.to change{ subject.balance }.by 1
    end
  end

  describe '#touch_in' do

    it 'raises error when insufficient balance' do
      expect{subject.touch_in(entry_station)}.to raise_error "Insufficient balance"
    end
  end

  describe '#touch_out' do

    before do
      subject.top_up(described_class::MAXIMUM_BALANCE)
      subject.touch_in(station_z1)
      subject.touch_out(station_z1)
    end

    it 'deducts penalty fare from card' do
      expect{ subject.touch_out(station_z1) }.to change{ subject.balance }.by (-Journey::PENALTY_FARE)
    end

  end

  describe '#initialize' do
    # it 'has empty list of journeys' do
    #   expect(subject.journey_history).to be_empty
    # end

    it 'balance is zero' do
      expect(subject.balance).to eq(0)
    end
  end

end
