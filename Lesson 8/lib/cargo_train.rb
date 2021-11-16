# frozen_string_literal: true

require_relative 'train'

class CargoTrain < Train
  private

  # Метод устанавливает тип поезда при инициализации
  def set_type
    @type = TRAIN_TYPES[1]
  end
end
