# frozen_string_literal: true

require 'optparse'

def main
  options = parse_command_line_options
  options = { l: true, w: true, c: true } if options.empty?
  paths = ARGV
  counts_data = count_by_input_content(paths)
  counts_data.each { |count| print_word_counts(count, options) }
  display_total_count(counts_data, options) if paths.length >= 2
end

def parse_command_line_options
  opt = OptionParser.new
  options = {}

  opt.on('-l') { |l| l }
  opt.on('-w') { |w| w }
  opt.on('-c') { |c| c }
  opt.parse!(ARGV, into: options)
  options
end

def count_by_input_content(paths)
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

def print_word_counts(count, options)
  word_counts = []
  word_counts << format_count(count[:lines]) if options[:l]
  word_counts << format_count(count[:words]) if options[:w]
  word_counts << format_count(count[:bytes]) if options[:c]
  word_counts << " #{count[:name]}" unless count[:name].empty?
  puts word_counts.join
end

def format_count(count)
  count.to_s.rjust(8)
end

def display_total_count(counts_data, options)
  total_counts = create_total_count(counts_data)
  print_word_counts(total_counts, options)
end

def create_total_count(counts_data)
  {
    lines: counts_data.sum { |count| count[:lines] },
    words: counts_data.sum { |count| count[:words] },
    bytes: counts_data.sum { |count| count[:bytes] },
    name: 'total'
  }
end

main
puts
