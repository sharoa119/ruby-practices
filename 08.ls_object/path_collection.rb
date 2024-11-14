# frozen_string_literal: true

class PathCollection
  def initialize(dotmatch: false, reverse: false)
    @dotmatch = dotmatch # 隠しファイルを含むかどうか
    @reverse = reverse # ファイルリストを逆順にするかどうか
  end

  def paths
    files = if @dotmatch # 隠しファイルを含める場合
              Dir.entries('.').sort # ディレクトリ内の全てのファイルと隠しファイル（. で始まるもの）を取得。その後、sort メソッドを使ってアルファベット順にソートする
            else # 隠しファイルを除外する場合
              Dir.glob('*') # 隠しファイルを除いたファイルを取得。
            end
    files.reverse! if @reverse # もし @reverse が true であれば、files.reverse! でファイルリストを逆順に並べ替える。
    files
  end
end
