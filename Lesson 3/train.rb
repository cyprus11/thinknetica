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

class Train
  attr_reader :speed, :vagons_count, :current_station

  def initialize(number, type, vagons_count)
    @number = number
    @type = type
    @vagons_count = vagons_count
    @speed = 0
    @route = nil
    @current_station = nil
  end

  def speed_up
    @speed += 10
  end

  def stop
    @speed = 0
  end

  def add_vagon
    @vagons_count += 1 if @speed == 0
  end

  def remove_vagon
    @vagons_count -= 1 if @vagons_count > 0 && @speed == 0
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
    @type == 'passenger'
  end

  def is_freight?
    @type == 'freight'
  end

  private

  def stations
    @route.all_stations
  end

  def train_to_station
    @current_station.take_train(self)
  end

  def train_out_from_station
    @current_station.send_train(self)
  end
end