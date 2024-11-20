# frozen_string_literal: true

class FileDetailDisplay
  def initialize(files)
    @files = files
  end

  def show
    long_formats = @files.map { |file| DetailedFile.new(file).attributes }
    max_size = calculate_max_column_widths(long_formats)
    total_blocks = long_formats.sum { |format| format[:blocks] }
    puts "total #{total_blocks}"

    long_formats.each do |format|
      line = [
        "#{format[:type]}#{format[:mode]}  ",
        "#{format[:nlink].rjust(max_size[:nlink])} ",
        "#{format[:username].ljust(max_size[:username])}  ",
        "#{format[:groupname].ljust(max_size[:groupname])}  ",
        "#{format[:bitesize].rjust(max_size[:bitesize])} ",
        "#{format[:mtime].rjust(max_size[:mtime])} ",
        format[:pathname]
      ]
      puts line.join
    end
  end

  private

  def calculate_max_column_widths(long_formats)
    {
      nlink: long_formats.map { |format| format[:nlink].size }.max,
      username: long_formats.map { |format| format[:username].size }.max,
      groupname: long_formats.map { |format| format[:groupname].size }.max,
      bitesize: long_formats.map { |format| format[:bitesize].size }.max,
      mtime: long_formats.map { |format| format[:mtime].size }.max
    }
  end
end
