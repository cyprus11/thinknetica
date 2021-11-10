require_relative 'train_wagon_types'

class Wagon
  attr_accessor :train
  attr_reader :type

  include TrainWagonTypes
  include TrainWagonmethods

  def initialize(train)
    @train = train
    set_type
    validate!
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

  private

  # метод переопределяется в дочерних классах для установления типа вагона
  def set_type
  end

  def validate!
    raise "You try add wagon to train with other type" if type != train.type
  end
end