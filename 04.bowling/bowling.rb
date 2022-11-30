# frozen_string_literal: true

PERFECT_SCORE = 10
score = ARGV[0]
all_scores = score.split(',')

frames = Array.new(10) { [] }
frame = 0
all_scores.each do |s|
  if frame == 9 # 0から始まるので10フレーム目は９になる。
    frames[frame] << (s == 'X' ? PERFECT_SCORE : s.to_i)
    next
  end

  if s == 'X'
    frames[frame] << PERFECT_SCORE
    frames[frame] << 0
    frame += 1
    next
  end
  frames[frame] << s.to_i

  if frames[frame].size == 2
    frame += 1
    next
  end
end

point = 0
frames.each.with_index(1) do |scores, i|
  point += scores.sum if i == 10
  if i != 10
    point += if scores[0] == 10 && i == 9
               10 + frames[i][0] + frames[i][1]
             elsif scores[0] == 10 && frames[i][0] == 10 # ストライクかつ次もストライクだった場合
               10 + frames[i][0] + frames[i + 1][0]
             elsif scores[0] == 10 # ストライク
               10 + frames[i][0] + frames[i][1]
             elsif scores.sum == 10 # スペア
               10 + frames[i][0]
             else
               scores.sum
             end
  end
end
puts point
