require_relative 'train_wagon_types'
require_relative 'place'

class Wagon
  attr_accessor :train
  attr_reader :type

  include TrainWagonTypes
  include TrainWagonmethods

  def initialize(train, places_count)
    @train = train
    @all_places = []
    set_type
    create_places(places_count)
    validate!
  end

  def is_passenger?
    @type == TRAIN_TYPES[0]
  end

  def is_cargo?
    @type == TRAIN_TYPES[1]
  end

  def free_places_count
    @all_places.count { |place| place.free? }
  end

  def occupied_places_count
    @all_places.count { |place| !place.free? }
  end

  def take_a_place(count = 0)
    return false if (count + occupied_places_count) == @all_places.size

    if count > 0
      occupied_count = occupied_places_count
      count.times { |i| @all_places[occupied_count + i].take }
    else
      @all_places[occupied_places_count].take
    end
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def to_s
    "#{is_passenger? ? 'Пассажирский' : 'Грузовой'} вагон, вместимостью: #{@all_places.size} #{place_type}, свободно: #{free_places_count} #{place_type}"
  end

  private

  # метод переопределяется в дочерних классах для установления типа вагона
  def set_type
    nil
  end

  def validate!
    raise "You try add wagon to train with other type" if type != train.type
  end

  def create_places(place_count)
    place_count.times { @all_places << Place.new(place_type)}
  end

  def place_type
    is_cargo? ?  WAGON_PLACES_TYPES[1] : WAGON_PLACES_TYPES[0]
  end
end
