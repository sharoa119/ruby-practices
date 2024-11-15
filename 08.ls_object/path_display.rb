# frozen_string_literal: true

class PathDisplay
  COLUMN_PADDING = 10

  def initialize(files, column: 3)
    @files = files
    @column = column
  end

  def show
    max_name_length = @files.map(&:length).max
    padded_files = @files.map { |file| file.ljust(max_name_length + COLUMN_PADDING) }

    padded_files.each_slice(@column) do |line|
      puts line.join
    end
  end
end
