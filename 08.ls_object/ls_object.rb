#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'path_collection'
require_relative 'path_display'
require_relative 'file_detail_display'

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

display = params[:l] ? FileDetailDisplay.new(paths) : PathDisplay.new(paths)
display.show
