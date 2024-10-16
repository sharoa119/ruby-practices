# frozen_string_literal: true

require_relative 'frame'

class Game
  PERFECT_SCORE = 10

  def initialize(score_string)
    @frames = Array.new(10) { Frame.new } # 10フレーム分のFrameインスタンスを持つ配列を作成。
    @shots = score_string.split(',') # 入力されたスコア（score_string）をカンマで区切って配列化し、各投球の結果（ストライクや倒したピンの数など）を保持する
    @current_frame = 0 # 現在のフレーム番号を保持する。最初は0始まり、フレームが進むごとに増える
  end

  def play # 実際のゲームの進行をシミュレート。投球結果をもとに各フレームに投球を追加し、ゲームを進める。
    @shots.each do |pin|# @shots配列に格納されたスコアを使ってフレームに投球を追加していく。
      @frames[@current_frame].add_shot(pin)
      if @current_frame < 9 && (@frames[@current_frame].strike? || @frames[@current_frame].shots.size == 2)
        @current_frame += 1
      end
    end
  end

  def total_score # ゲーム全体のスコアを計算
    score = 0
    @frames.each_with_index do |frame, index|
      score += frame.score # 各フレームの基本スコアを加算

      if frame.strike? # ストライクだったら
        score += bonus_for_strike(index) # ストライクのボーナスを追加
      elsif frame.spare? # スペアだったら
        score += bonus_for_spare(index) # スペアのボーナスを追加
      end
    end
    score
  end

  private

  def bonus_for_strike(index) # ストライクのボーナス
    return 0 if index == 9 # 10フレーム目だったら ボーナスは計算しない（10フレーム目は最後なので次の投球がない）。

    next_frame = @frames[index + 1] # 次のフレームの情報を代入する
    if next_frame.strike? # 次のフレームがストライクだった場合
      if index == 8 # 9フレーム目でストライクを取った場合
        ERFECT_SCORE + next_frame.shots[0].pins # 10フレーム目の1投目だけを加算
      else
        ERFECT_SCORE + @frames[index + 2].shots[0].pins # 2フレーム後の1投目も加算
      end
    else
      next_frame.shots[0].pins + next_frame.shots[1].pins
    end
  end

  def bonus_for_spare(index) # スペアのボーナス
    return 0 if index == 9

    @frames[index + 1].shots[0].pins # 次のフレームの1投目のスコアをボーナスとして加算
  end
end
