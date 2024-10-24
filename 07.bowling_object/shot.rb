# frozen_string_literal: true

class Shot
  PERFECT_SCORE = 10

  attr_reader :pins

  def initialize(pin)
    @pins = pin == 'X' ? PERFECT_SCORE : pin.to_i
  end
end
