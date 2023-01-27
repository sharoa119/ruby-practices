# frozen_string_literal: true

# この列で表示したい
def column
  5
end

def find_files
  path = Dir.pwd
  Dir.chdir(path)
  Dir.glob('*')
end

def display_files
  max_line = (find_files.size / column.to_f).ceil

  files = []
  find_files.each_slice(max_line) do |f|
    files << f
  end
  # その中から最大要素数を取得
  max_size = files.map(&:size).max
  # 各配列の要素数を最大要素数に合わせる
  files.map! { |x| x.values_at(0...max_size) }

  # 行と列を入れ替えて、さらに二次元配列を一次元配列にする
  files.transpose.flatten
end

# 表示する
display_files.map.with_index(1) do |file, index|
  if (index % column).zero?
    puts file.to_s.ljust(25)
  else
    print file.to_s.ljust(25)
  end
end
