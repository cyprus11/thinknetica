# frozen_string_literal: true

require_relative 'train_wagon_types'

class Train
  extend Accessors
  include TrainWagonTypes
  include TrainWagonmethods
  include InstanceCounter
  include Validation

  TRAIN_NUMBER = /\A([a-z]{3}|\d{3})-?([a-z]{2}|\d{2})\z/i.freeze

  attr_reader :speed, :wagons, :current_station, :type, :number

  validate :number, :presence
  validate :number, :format, TRAIN_NUMBER

  @@all_trains = []

  def self.find(train_number)
    @@all_trains.detect { |train| train.number == train_number }
  end

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    @route = nil
    @current_station = nil
    set_type
    validate!
    @@all_trains << self
    register_instance
  end

  def speed_up
    @speed += 10
  end

  def stop
    @speed = 0
  end

  def add_wagon(wagon)
    @wagons << wagon if @speed.zero? && type == wagon.type
  end

  def remove_wagon
    wagon = @wagons.pop if @speed.zero?
    wagon.train = nil
  end

  def route(route)
    @route = route
    @current_station = stations.first
    train_to_station
  end

  def move_forward
    return if @current_station == @route.last_station

    train_out_from_station
    @current_station = stations[stations.index(@current_station) + 1]
    train_to_station
  end

  def move_back
    return if @current_station == @route.first_station

    train_out_from_station
    @current_station = stations[stations.index(@current_station) - 1]
    train_to_station
  end

  def prev_station
    stations[stations.index(@current_station) - 1] unless @current_station == @route.first_station
  end

  def next_station
    stations[stations.index(@current_station) + 1] unless @current_station == @route.last_station
  end

  def passenger?
    @type == TRAIN_TYPES[0]
  end

  def cargo?
    @type == TRAIN_TYPES[1]
  end

  def to_s
    if passenger?
      "Пассажирский поезд № #{number}"
    else
      "Грузовой поезд № #{number}"
    end
  end

  def action_with_wagons(&block)
    @wagons.each(&block)
  end

  private

  # данный метод вызывается в initializer и переопределяется у дочерних классов,
  # тем самым устанавливая тип поезда
  def set_type
    nil
  end

  # данный метод используется внутри методов экземпляра класса, нет необходимости предоставлять
  # открытый доступ к данному методу, так как предоставлять список станций - функционал клсса Route
  def stations
    @route.all_stations
  end

  # данный метод нужен для использования внутри методов экземпляра класса для
  # установления 'связи' между станцией и поездом
  def train_to_station
    @current_station.take_train(self)
  end

  # данный метод нужен для использования внутри методов экземпляра класса для
  # разрыва 'связи' между станцией и поездом
  def train_out_from_station
    @current_station.send_train(self)
  end
end
