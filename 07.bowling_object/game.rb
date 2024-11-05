# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(score)
    @frames = Array.new(10) { Frame.new }
    @shots = score.split(',')
    @current_frame = 0
  end

  def play
    @shots.each do |pin|
      @frames[@current_frame].add_shot(pin)

      next unless @current_frame < 9 && (@frames[@current_frame].strike? || @frames[@current_frame].shots.size == 2)

      @current_frame += 1
    end
  end

  def total_score
    score = 0
    @frames.each_with_index do |frame, index|
      score += frame.score
      if frame.strike?
        bonus = bonus_for_strike(index)
        score += bonus
      elsif frame.spare?
        bonus = bonus_for_spare(index)
        score += bonus
      end
    end
    score
  end

  private

  def bonus_for_strike(index)
    return 0 if index == 9

    next_frame = @frames[index + 1]
    bonus = next_frame.shots[0].pin_count

    if next_frame.strike?
      if index == 8
        bonus += next_frame.shots[1].pin_count
      elsif index + 2 < @frames.size
        bonus += @frames[index + 2].shots[0].pin_count
      end
    elsif next_frame.shots.size > 1
      bonus += next_frame.shots[1].pin_count
    end

    bonus
  end

  def bonus_for_spare(index)
    return 0 if index == 9

    @frames[index + 1].shots[0].pin_count
  end
end
