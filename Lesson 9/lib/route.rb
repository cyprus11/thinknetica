# frozen_string_literal: true

class Route
  extend Accessors
  include InstanceCounter
  include Validation

  validate :first_station, :type, Station
  validate :last_station, :type, Station

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @stations = []
    validate!
    register_instance
  end

  def add_station(station)
    @stations << station
  end

  def delete_station(station)
    @stations.delete(station)
  end

  def all_stations
    [@first_station, @stations, @last_station].flatten
  end

  def print_stations
    all_stations.each do |station|
      puts station.name
    end
  end

  def last_station
    all_stations.last
  end

  def first_station
    all_stations.first
  end
end
