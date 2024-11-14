#!/usr/bin/env ruby
# frozen_string_literal: true

# 必要なファイルをrequire
require_relative 'path_collection'
require_relative 'path_display'
require_relative 'file_detail_display'
require_relative 'detailed_file'

# コマンドライン引数を取得
params = ARGV.getopts('alr')

# ファイルのリストを取得
path_collection = PathCollection.new(dotmatch: params['a'], reverse: params['r'])
paths = path_collection.paths

# 出力方法を選択
if params['l']
  # 詳細表示用のインスタンスを生成し、表示
  file_details = paths.map { |path| DetailedFile.new(path) }
  file_detail_display = FileDetailDisplay.new(file_details)
  file_detail_display.show
else
  # 列表示用のインスタンスを生成し、表示
  path_display = PathDisplay.new(paths)
  path_display.show
end
