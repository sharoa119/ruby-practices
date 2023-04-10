# frozen_string_literal: true

require 'optparse'

def main
  options = option_date
  options = { l: true, w: true, c: true } if options.empty?
  paths = ARGV
  counts_date = display_date(paths)
  counts_date.map { |count| display_word_count(count, options) }
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
    [count_file_stats(files)]
  else
    paths.map do |path|
      files = File.read(path)
      count_file_stats(files, path)
    end
  end
end

def count_file_stats(files, path = ' ')
  {
    lines: files.gsub(/^\s+$/, '').count("\n"),
    words: files.gsub(/^\s+$/, '').split(/\s+/).count,
    bytes: files.bytesize,
    name: path
  }
end

def display_word_count(count, options)
  word_count_format = []
  word_count_format << count_format(count[:lines]) if options[:l]
  word_count_format << count_format(count[:words]) if options[:w]
  word_count_format << count_format(count[:bytes]) if options[:c]
  word_count_format << " #{count[:name]}" unless count[:name].empty?
  puts word_count_format.join
end

def count_format(count)
  count.to_s.rjust(8)
end

def display_total_count(counts_date, options)
  total_counts = create_total_count(counts_date)
  display_word_count(total_counts, options)
end

def create_total_count(counts_date)
  {
    lines: counts_date.sum { |count| count[:lines] },
    words: counts_date.sum { |count| count[:words] },
    bytes: counts_date.sum { |count| count[:bytes] },
    name: 'total'
  }
end

main
puts
