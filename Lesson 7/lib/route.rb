# Класс Route (Маршрут):
# Имеет начальную и конечную станцию, а также список промежуточных станций. Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
# Может добавлять промежуточную станцию в список
# Может удалять промежуточную станцию из списка
# Может выводить список всех станций по-порядку от начальной до конечной

class Route

  include InstanceCounter

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @stations = []
    validate!
    self.register_instance
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

  def valid?
    validate!
    true
  rescue
    false
  end

  private

  def validate!
    raise "Wrong stations" unless first_station.is_a?(Station) && last_station.is_a?(Station)
  end
end