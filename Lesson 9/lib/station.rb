# frozen_string_literal: true

class Station
  attr_reader :name, :trains

  STATION_NAME = /\w+/i.freeze

  include InstanceCounter
  include Validation

  validate :name, :presence
  validate :name, :format, STATION_NAME

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

  def action_with_trains(&block)
    @trains.each(&block)
  end
end
