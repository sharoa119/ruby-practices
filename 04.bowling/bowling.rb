# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

frames = Array.new(10) { [] }
frame = 1
scores.each do |s|
  if frame == 10
    frames[frame - 1] << if s == 'X'
                           10
                         else
                           s.to_i
                         end
    next
  end

  if s == 'X'
    frames[frame - 1] << 10
    frames[frame - 1] << 0
    frame += 1
    next
  end
  frames[frame - 1] << s.to_i

  if frames[frame - 1].size == 2
    frame += 1
    next
  end
end

point = 0
frame = 1
frames.each do |count|
  point += count.sum if frame == 10

  if frame != 10
    point += if count[0] == 10 && frame == 9
               10 + frames[frame][0] + frames[frame][1]
             elsif count[0] == 10 && frames[frame][0] == 10 # ストライクかつ次もストライクだった場合
               10 + frames[frame][0] + frames[frame + 1][0]
             elsif count[0] == 10 # ストライク
               10 + frames[frame][0] + frames[frame][1]
             elsif count.sum == 10 # スペア
               10 + frames[frame][0]
             else
               count.sum
             end
  end
  frame += 1
end
puts point
