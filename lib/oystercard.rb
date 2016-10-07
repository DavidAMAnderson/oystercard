
require_relative 'journey'
require_relative 'journey_log'
require_relative 'station'

class Oystercard

  attr_reader :balance

  MAXIMUM_BALANCE = 90

  def initialize (journey_log = JourneyLog.new)
    @balance = 0
    @journey_log = journey_log
  end

  def top_up(money)
    fail "Beyond limit of #{MAXIMUM_BALANCE}" if (balance + money) > MAXIMUM_BALANCE
    @balance += money
  end

  def touch_in(station)
    fail "Insufficient balance" if balance < Journey::MINIMUM_FARE
    deduct(journey_log.outstanding_charges)
    journey_log.start(station)
  end

  def touch_out(station)
    journey_log.finish(station)
    deduct(journey_log.journeys.last.fare)
  end

  private

  attr_reader :journey_log

  def deduct(money)
    @balance -= money
  end

end
