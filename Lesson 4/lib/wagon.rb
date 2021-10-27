require_relative 'train_wagon_types'

class Wagon
  attr_accessor :train
  attr_reader :type

  include TrainWagonTypes

  def initialize(train)
    @train = train
    set_type
  end

  def is_passenger?
    @type == TRAIN_TYPES[0]
  end

  def is_cargo?
    @type == TRAIN_TYPES[1]
  end

  private

  # метод переопределяется в дочерних классах для установления типа вагона
  def set_type
  end
end