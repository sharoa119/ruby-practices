# frozen_string_literal: true

require 'optparse'
require 'etc'

PARAMS = ARGV.getopts('alr')

COLUMN = 3

TYPE_SYMBOL = {
  'fifo' => 'p',
  'characterSpecial' => 'c',
  'directory' => 'd',
  'blockSpecial' => 'b',
  'file' => '-',
  'link' => 'l',
  'socket' => 's'
}.freeze

MODE_SYMBOL = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

def files_to_show
  files = find_files
  if PARAMS['l']
    long_format_lineup(files)
  else
    column_lineup(files)
  end
end

def find_files
  path = Dir.pwd
  Dir.chdir(path)
  files = if PARAMS['a']
            Dir.entries('.').sort
          else
            Dir.glob('*')
          end
  files = files.reverse if PARAMS['r']
  files
end

def column_lineup(files)
  max_name_len = find_files.map(&:length).max
  display_files = display_column_files(files)
  display_files.map.with_index(1) do |file, index|
    print file.to_s.ljust(max_name_len + 10)
    puts if (index % COLUMN).zero?
  end
end

def display_column_files(_files)
  max_line = (find_files.size / COLUMN.to_f).ceil
  column_files = find_files.each_slice(max_line).to_a

  max_size = column_files.map(&:size).max
  column_files.map! { |x| x.values_at(0...max_size) }

  column_files.transpose.flatten
end

def long_format_lineup(files)
  long_formats = get_long_formats(files)
  max_size = get_max_size(long_formats)
  total_blocks = long_formats.map { |long_format| long_format[:blocks] }.sum
  puts "total #{total_blocks}"

  long_formats.each do |long_format|
    print "#{long_format[:type]}#{long_format[:mode]} "
    print "#{long_format[:nlink].rjust(max_size[:nlink])} "
    print "#{long_format[:username].ljust(max_size[:username])}  "
    print "#{long_format[:groupname].ljust(max_size[:groupname])}  "
    print "#{long_format[:bitesize].rjust(max_size[:bitesize])} "
    print  "#{long_format[:mtime]} "
    print  "#{long_format[:pathname]}\n"
  end
end

def get_long_formats(files)
  long_formats = []
  files.each do |file|
    file_stat = File.stat(file)
    long_format = {
      blocks: file_stat.blocks,
      type: type_format(file_stat.ftype),
      mode: mode_format(file_stat.mode),
      nlink: file_stat.nlink.to_s,
      username: Etc.getpwuid(file_stat.uid).name,
      groupname: Etc.getgrgid(file_stat.gid).name,
      bitesize: bitesize(file_stat),
      mtime: mtime(file_stat),
      pathname: filename(file)
    }
    long_formats << long_format
  end
  long_formats
end

def get_max_size(long_formats)
  {
    nlink: long_formats.map { |long_format| long_format[:nlink].size }.max,
    username: long_formats.map { |long_format| long_format[:username].size }.max,
    groupname: long_formats.map { |long_format| long_format[:groupname].size }.max,
    bitesize: long_formats.map { |long_format| long_format[:bitesize].size }.max
  }
end

def type_format(type)
  TYPE_SYMBOL[type]
end

def mode_format(mode)
  octal_num = mode.to_s(8).rjust(6, '0')
  permissions_num = octal_num.slice(3..5).split(//)
  permissions_group = permissions_num.map { |n| MODE_SYMBOL[n] }
  special_authorization(octal_num, permissions_group).join
end

def special_authorization(octal_num, permissions_group)
  case octal_num.slice(2)
  when '1'
    permissions_group[2] = permissions_group[2].gsub(/.$/, permissions_group[2].slice(2) == 'x' ? 't' : 'T')
  when '2'
    permissions_group[1] = permissions_group[1].gsub(/.$/, permissions_group[1].slice(2) == 'x' ? 's' : 'S')
  when '4'
    permissions_group[0] = permissions_group[0].gsub(/.$/, permissions_group[0].slice(2) == 'x' ? 's' : 'S')
  end
  permissions_group
end

def bitesize(file_stat)
  if file_stat.rdev != 0
    "#{file_stat.rdev_major}, #{file_stat.rdev_minor}"
  else
    file_stat.size.to_s
  end
end

def mtime(file_stat)
  if Time.now - file_stat.mtime >= (24 * 60 * 60 * (365 / 2.0)) || (Time.now - file_stat.mtime).negative?
    file_stat.mtime.strftime('%_m %_d %Y')
  else
    file_stat.mtime.strftime('%_m %_d %H:%M')
  end
end

def filename(file)
  if File.symlink?(file)
    "#{file} -> #{File.readlink(file)}"
  else
    file
  end
end

files_to_show
puts
