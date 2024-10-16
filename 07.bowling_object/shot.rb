# frozen_string_literal: true

class Shot
  PERFECT_SCORE = 10

  attr_reader :pins

  def initialize(pin) # 引数pinsを渡す
    @pins = pins == 'X' ? PERFECT_SCORE : pin.to_i # pinsがXだったら10を代入。それ以外だったら、整数に変換して代入。
  end
end
