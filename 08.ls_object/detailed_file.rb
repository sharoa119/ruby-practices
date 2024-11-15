# frozen_string_literal: true

require 'etc'

class DetailedFile
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

  def initialize(file)
    @file = file
  end

  def attributes
    file_stat = File.stat(@file)
    {
      blocks: file_stat.blocks,
      type: TYPE_SYMBOL[file_stat.ftype],
      mode: format_mode(file_stat.mode),
      nlink: file_stat.nlink.to_s,
      username: Etc.getpwuid(file_stat.uid).name,
      groupname: Etc.getgrgid(file_stat.gid).name,
      bitesize: file_stat.rdev != 0 ? "#{file_stat.rdev_major}, #{file_stat.rdev_minor}" : file_stat.size.to_s,
      mtime: format_mtime(file_stat),
      pathname: File.symlink?(@file) ? "#{@file} -> #{File.readlink(@file)}" : @file
    }
  end

  private

  def format_mode(mode)
    octal = mode.to_s(8).rjust(6, '0')
    permissions = octal[-3..].chars.map { |n| MODE_SYMBOL[n] }

    case octal[2]
    when '1'
      permissions[2][-1] = permissions[2][-1] == 'x' ? 't' : 'T'
    when '2'
      permissions[1][-1] = permissions[1][-1] == 'x' ? 's' : 'S'
    when '4'
      permissions[0][-1] = permissions[0][-1] == 'x' ? 's' : 'S'
    end

    permissions.join
  end

  def format_mtime(file_stat)
    if Time.now - file_stat.mtime >= (24 * 60 * 60 * (365 / 2.0)) || (Time.now - file_stat.mtime).negative?
      file_stat.mtime.strftime('%_m %_d %Y')
    else
      file_stat.mtime.strftime('%_m %_d %H:%M')
    end
  end
end
