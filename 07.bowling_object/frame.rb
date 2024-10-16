# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots

  def initialize
    @shots = [] # shotsに空の配列を初期値として渡す、なぜならframeが呼び出されるたびクリアになっているべきだから。
  end

  def add_shot(pin) # 投げた時のpinをshotsに追加していく。
    @shots << Shot.new(pin)
  end

  def strike? # ストライクかの確認メソッド
    @shots[0].pins == 10 # 1回目で投げた時にpinsの数値が10だったら。（[0]はインデックスで1回目。）
  end

  def spare? # スペアかの確認メソッド
    @shots.size == 2 && @shots.sum(&:pins) == 10 # shotsが2回分あって、尚且つ、その2つの数値を足した数が10だったら。
  end

  def score
    @shots.sum(&:pins) # pinsを足した数がスコア。
  end
end
