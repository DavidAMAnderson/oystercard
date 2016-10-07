class Journey

  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  attr_reader :entry_station, :exit_station

  def initialize(entry_station = nil)
    @entry_station = entry_station
    @complete = false
  end

  def end(exit_station = nil)
    @exit_station = exit_station
    @complete = true
    self
  end

  def complete?
      @complete
  end

  def fare
    if @entry_station == nil || @exit_station == nil
      PENALTY_FARE
    else
      (@entry_station.zone - @exit_station.zone).abs + MINIMUM_FARE
    end
  end
end
