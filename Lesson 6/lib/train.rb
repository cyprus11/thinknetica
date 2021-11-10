# Класс Train (Поезд):
# Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
# Может набирать скорость
# Может возвращать текущую скорость
# Может тормозить (сбрасывать скорость до нуля)
# Может возвращать количество вагонов
# Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов). Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
# Может принимать маршрут следования (объект класса Route).
# При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
# Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
# Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
require_relative 'train_wagon_types'

class Train
  attr_reader :speed, :wagons, :current_station, :type, :number

  TRAIN_NUMBER = /^([a-z]{3}|[\d]{3})-?([a-z]{2}|[\d]{2})/i

  include TrainWagonTypes
  include TrainWagonmethods
  include InstanceCounter

  @@all_trains = []

  def self.find(train_number)
    @@all_trains.select{ |train| train.number == train_number }.first
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
    self.register_instance
  end

  def speed_up
    @speed += 10
  end

  def stop
    @speed = 0
  end

  def add_wagon(wagon)
    @wagons << wagon if @speed == 0 && self.type == wagon.type
  end

  def remove_wagon
    wagon = @wagons.pop if @speed == 0
    wagon.train = nil
  end

  def set_route(route)
    @route = route
    @current_station = stations.first
    train_to_station
  end

  def move_forward
    unless @current_station == @route.last_station
      train_out_from_station
      @current_station = stations[stations.index(@current_station) + 1]
      train_to_station
    end
  end

  def move_back
    unless @current_station == @route.first_station
      train_out_from_station
      @current_station = stations[stations.index(@current_station) - 1]
      train_to_station
    end
  end

  def prev_station
    stations[stations.index(@current_station) - 1] unless @current_station == @route.first_station
  end

  def next_station
    stations[stations.index(@current_station) + 1] unless @current_station == @route.last_station
  end

  def is_passenger?
    @type == TRAIN_TYPES[0]
  end

  def is_cargo?
    @type == TRAIN_TYPES[1]
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def to_s
    if is_passenger?
      "Пассажирский поезд № #{number}"
    else
      "Грузовой поезд № #{number}"
    end
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

  def validate!
    raise "Number length is #{number.length}. Minimum it should be equal 5" if number.length < 5
    raise "Your number #{number} not valid. Number should be like: AAA-FF or 333-AA or 333AA" if number !~ TRAIN_NUMBER
  end
end