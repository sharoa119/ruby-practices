# frozen_string_literal: true

class PathDisplay
  COLUMN_PADDING = 10

  def initialize(files, column: 3)
    @files = files
    @column = column
  end

  def show
    files_in_order = rearrange_files(@files)

    max_name_length = files_in_order.map(&:length).max
    files_in_order.each_with_index do |file, index|
      print file.ljust(max_name_length + COLUMN_PADDING)
      puts if ((index + 1) % @column).zero?
    end
    puts if files_in_order.size % @column != 0
  end

  private

  def rearrange_files(files)
    max_line = (files.size.to_f / @column).ceil
    column_files = files.each_slice(max_line).to_a

    max_size = column_files.map(&:size).max
    column_files.each { |col| col.fill(nil, col.size...max_size) }

    rearranged = []
    max_size.times do |i|
      column_files.each do |col|
        rearranged << (col[i] || '')
      end
    end

    rearranged
  end
end
