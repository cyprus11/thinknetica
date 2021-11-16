# frozen_string_literal: true

class Station
  attr_reader :name, :trains

  STATION_NAME = /\w+/i.freeze

  include InstanceCounter

  @@all_stations = []

  def self.all_stations
    @@all_stations
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@all_stations << self
    register_instance
  end

  def take_train(train)
    @trains << train
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def send_train(train)
    @trains.delete(train)
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def action_with_trains(&block)
    @trains.each(&block)
  end

  private

  def validate!
    raise 'Too short name for station. It should be min 3.' if name.length < 3
    raise 'Station name is incorrect.' if name !~ STATION_NAME
  end
end
