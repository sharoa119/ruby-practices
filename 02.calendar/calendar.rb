require "date"
require 'optparse'

opt = OptionParser.new
parmas = {}

opt.on('-m MONTH') { |v| parmas[:m] = v.to_i }
opt.on('-y YEAR') { |v| parmas[:y] = v.to_i }
opt.parse(ARGV)

#今日の日付
today = Date.today

#今日の日付から月と年
month = today.month
year = today.year


v = parmas[:m]
x = parmas[:y]
if v != nil && x != nil  #もし年月の指定があったら
  month = parmas[:m]
  year = parmas[:y]
elsif v != nil           #もし月の指定があったら
  month = parmas[:m]
  year = today.year
else                     #指定がなければ
  month = today.month
  year = today.year
end

title = "#{month}月 #{year}"
puts title.center(20)

#日から土を表示する
week = %w(日 月 火 水 木 金 土)
puts week.join(" ")


first_day = Date.new(year, month, 1).day   #月の最初の日を返す
last_day = Date.new(year, month, -1).day   #月の最後の日を返す
fwday = Date.new(year, month, 1).wday     #月の最初の曜日を返す
space = ("   ") * fwday
print space

#カレンダーを表示する

(first_day..last_day).each do |date|
dweek = Date.new(year, month, date).wday  #1から最後の日までの曜日を返す
dday = date.to_s
day = sprintf("%2s", dday) 
  if dweek == 6
    print "#{day}\n"
  else
    print (day + " ")
  end
end

