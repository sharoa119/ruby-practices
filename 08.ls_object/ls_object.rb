#!/usr/bin/env ruby
# frozen_string_literal: true

# 必要なファイルをrequire
require_relative 'path_collection'
require_relative 'path_display'
require_relative 'file_detail_display'
require_relative 'detailed_file'

params = ARGV.getopts('alr')

# ファイルのリストを取得
path_collection = PathCollection.new(params)
paths = path_collection.paths

# 出力方法を選択
if params['l']
  file_details = paths.map { |path| DetailedFile.new(path) }
  file_detail_display = FileDetailDisplay.new(file_details)
  file_detail_display.show
else
  path_display = PathDisplay.new(paths)
  path_display.show
end
