# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots

  def initialize
    @shots = []
  end

  def add_shot(pin)
    @shots << Shot.new(pin)
  end

  def strike?
    @shots[0].pin_count == 10
  end

  def spare?
    @shots.size == 2 && @shots.sum(&:pin_count) == 10
  end

  def complete?
    strike? || @shots.size == 2
  end

  def score
    @shots.sum(&:pin_count)
  end
end
