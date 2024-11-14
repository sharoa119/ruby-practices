# frozen_string_literal: true

class PathDisplay
  COLUMN_PADDING = 10

  def initialize(files, column: 3)
    @files = files
    @column = column
  end

  def show
    max_name_length = display_column_files.map(&:length).max
    display_column_files.each_with_index do |file, index|
      print file.ljust(max_name_length + COLUMN_PADDING)
      puts if (index % @column).zero?
    end
  end

  private

  def display_column_files
    max_line = (@files.size / COLUMN.to_f).ceil
    column_files = @files.each_slice(max_line).to_a
    column_files.transpose.flatten
  end
end
