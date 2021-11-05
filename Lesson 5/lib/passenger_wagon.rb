require_relative 'wagon'

class PassengerWagon < Wagon

  private

  # Метод устанавливает тип вагона при инициализации
  def set_type
    @type = TRAIN_TYPES[0]
  end
end