# frozen_string_literal: true

class Place
  def initialize(type)
    @type = type
    @free = true
  end

  def free?
    @free
  end

  def take
    @free = false
  end
end
