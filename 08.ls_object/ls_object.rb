# frozen_string_literal: true

# 必要なファイルをrequire
require_relative 'path_collection'
require_relative 'path_display'
require_relative 'file_detail_display'
require_relative 'detailed_file'

params = ARGV.getopts('alr')
