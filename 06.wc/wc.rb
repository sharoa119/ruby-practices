# frozen_string_literal: true

require 'optparse'

def bundled_date
  options = option_date
  options = { l: true, w: true, c: true } if options.empty?
  paths = ARGV
  counts_date = display_date(paths)
  counts_date.map { |count| word_count_to_show(count, options) }
  display_total_count(counts_date, options) if paths.length >= 2
end

def option_date
  opt = OptionParser.new
  options = {}

  opt.on('-l') { |l| l }
  opt.on('-w') { |w| w }
  opt.on('-c') { |c| c }
  opt.parse!(ARGV, into: options)
  options
end

def display_date(paths)
  if paths.empty?
    files = $stdin.read
    [counting_how_to(files)]
  else
    paths.map do |path|
      files = File.read(path)
      counting_how_to(files, path)
    end
  end
end

def counting_how_to(files, path = '')
  {
    lines: files.count("\n"),
    words: files.split(/\s+/).count,
    bytes: files.bytesize,
    name: path
  }
end

def word_count_to_show(count, options)
  word_count_format = []
  word_count_format << decide_format(count[:lines]) if options[:l]
  word_count_format << decide_format(count[:words]) if options[:w]
  word_count_format << decide_format(count[:bytes]) if options[:c]
  word_count_format << " #{count[:name]}" unless count[:name].empty?
  puts word_count_format.join
end

def decide_format(count)
  count.to_s.rjust(8)
end

def display_total_count(counts_date, options)
  total_counts = create_total_count(counts_date)
  word_count_to_show(total_counts, options)
end

def create_total_count(counts_date)
  {
    lines: counts_date.sum { |count| count[:lines] },
    words: counts_date.sum { |count| count[:words] },
    bytes: counts_date.sum { |count| count[:bytes] },
    name: 'total'
  }
end

bundled_date
puts
