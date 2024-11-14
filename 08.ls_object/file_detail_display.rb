# frozen_string_literal: true

class FileDetailDisplay
  def initialize(files)
    @files = files
  end

  def show
    long_formats = @files.map { |file| DetailedFile.new(file).attributes }
    max_size = get_max_size(long_formats)
    total_blocks = long_formats.map { |format| format[:blocks] }.sum
    puts "total #{total_blocks}"
    long_formats.each do |format|
      print "#{format[:type]}#{format[:mode]} "
      print "#{format[:nlink].rjust(max_size[:nlink])} "
      print "#{format[:username].ljust(max_size[:username])}  "
      print "#{format[:groupname].ljust(max_size[:groupname])}  "
      print "#{format[:bitesize].rjust(max_size[:bitesize])} "
      print "#{format[:mtime]} "
      print "#{format[:pathname]}\n"
    end
  end

  private

  def get_max_size(long_formats)
    {
      nlink: long_formats.map { |format| format[:nlink].size }.max,
      username: long_formats.map { |format| format[:username].size }.max,
      groupname: long_formats.map { |format| format[:groupname].size }.max,
      bitesize: long_formats.map { |format| format[:bitesize].size }.max
    }
  end
end

