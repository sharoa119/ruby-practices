#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'column_display'
require_relative 'long_format_display'

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

display = params[:l] ? LongFormatDisplay.new(paths) : ColumnDisplay.new(paths)
display.show
