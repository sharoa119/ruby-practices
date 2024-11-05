# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(score)
    @frames = Array.new(10) { Frame.new }
    @score_data = score.split(',')
    play
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

  def play
    frame_index = 0
    @score_data.each do |pin|
      @frames[frame_index].add_shot(pin)

      frame_index += 1 if frame_index < 9 && (@frames[frame_index].strike? || @frames[frame_index].shots.size == 2)
    end
  end

  def bonus_for_strike(index)
    return 0 if index == 9

    next_frame = @frames[index + 1]
    bonus = next_frame.shots[0].pin_count

    bonus += if next_frame.strike?
               index == 8 ? next_frame.shots[1].pin_count : @frames[index + 2].shots[0].pin_count
             else
               next_frame.shots[1].pin_count
             end

    bonus
  end

  def bonus_for_spare(index)
    return 0 if index == 9

    @frames[index + 1].shots[0].pin_count
  end
end
