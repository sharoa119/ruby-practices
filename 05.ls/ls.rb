# frozen_string_literal: true

COLUMN = 3

def find_files
  path = Dir.pwd
  Dir.chdir(path)
  Dir.glob('*')
end

max_name_len = find_files.map(&:length).max

def display_files
  max_line = (find_files.size / COLUMN.to_f).ceil
  files = find_files.each_slice(max_line).to_a

  max_size = files.map(&:size).max
  files.map! { |x| x.values_at(0...max_size) }

  files.transpose.flatten
end

display_files.map.with_index(1) do |file, index|
  if (index % COLUMN).zero?
    puts file.to_s.ljust(max_name_len + 10)
  else
    print file.to_s.ljust(max_name_len + 10)
  end
end
print("\n")
