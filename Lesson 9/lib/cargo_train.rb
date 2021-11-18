# frozen_string_literal: true

require_relative "train"

class CargoTrain < Train
  include Validation

  validate :number, :presence
  validate :number, :format, TRAIN_NUMBER

  private

  # Метод устанавливает тип поезда при инициализации
  def set_type
    @type = TRAIN_TYPES[1]
  end
end
