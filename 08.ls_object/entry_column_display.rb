# frozen_string_literal: true

class EntryColumnDisplay
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
    column_files.each { |col| col.fill('', col.size...max_line) }
    column_files.transpose.flatten
  end
end
