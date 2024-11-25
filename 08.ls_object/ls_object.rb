#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'entry_column_display'
require_relative 'long_format_file_list'

require 'optparse'

params = {}
OptionParser.new do |opts|
  opts.on('-a') { params[:a] = true }
  opts.on('-l') { params[:l] = true }
  opts.on('-r') { params[:r] = true }

  opts.parse!(ARGV)
end

paths = if params[:a]
          Dir.entries('.').sort
        else
          Dir.glob('*')
        end
paths.reverse! if params[:r]

display = params[:l] ? LongFormatFileList.new(paths) : EntryColumnDisplay.new(paths)
display.show
