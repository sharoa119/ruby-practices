#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'path_collection'
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

path_collection = PathCollection.new(dotmatch: params[:a], reverse: params[:r])
paths = path_collection.paths

display = params[:l] ? LongFormatFileList.new(paths) : EntryColumnDisplay.new(paths)
display.show
