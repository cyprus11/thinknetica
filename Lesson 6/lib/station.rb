# Класс Station (Станция):
# Имеет название, которое указывается при ее создании
# Может принимать поезда (по одному за раз)
# Может возвращать список всех поездов на станции, находящиеся в текущий момент
# Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
# Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).


class Station
  attr_reader :name, :trains

  STATION_NAME = /\w+/i

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
    self.register_instance
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
  rescue
    false
  end

  private

  def validate!
    raise "Too short name for station. It should be min 3." if name.length < 3
    raise "Station name is incorrect." if name !~ STATION_NAME
  end
end