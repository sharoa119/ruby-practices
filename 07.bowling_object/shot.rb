# frozen_string_literal: true

class Shot
  PERFECT_SCORE = 10

  attr_reader :pin_count

  def initialize(pin)
    @pin_count = pin == 'X' ? PERFECT_SCORE : pin.to_i
  end
end
