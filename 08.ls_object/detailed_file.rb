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
      type: type_format(file_stat.ftype),
      mode: mode_format(file_stat.mode),
      nlink: file_stat.nlink.to_s,
      username: Etc.getpwuid(file_stat.uid).name,
      groupname: Etc.getgrgid(file_stat.gid).name,
      bitesize: bitesize(file_stat),
      mtime: mtime(file_stat),
      pathname: filename
    }
  end

  private

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
    file_stat.rdev != 0 ? "#{file_stat.rdev_major}, #{file_stat.rdev_minor}" : file_stat.size.to_s
  end

  def mtime(file_stat)
    if Time.now - file_stat.mtime >= (24 * 60 * 60 * (365 / 2.0)) || (Time.now - file_stat.mtime).negative?
      file_stat.mtime.strftime('%_m %_d %Y')
    else
      file_stat.mtime.strftime('%_m %_d %H:%M')
    end
  end

  def filename
    if File.symlink?(@file)
      "#{@file} -> #{File.readlink(@file)}"
    else
      @file
    end
  end
end
