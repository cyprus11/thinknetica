require_relative 'wagon'

class CargoWagon < Wagon

  private

  # Метод устанавливает тип вагона при инициализации
  def set_type
    @type = TRAIN_TYPES[1]
  end
end
