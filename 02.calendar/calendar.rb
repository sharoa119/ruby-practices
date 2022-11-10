require "date"
require 'optparse'

opt = OptionParser.new
parmas = {}

opt.on('-m MONTH') { |v| parmas[:m] = v.to_i }
opt.on('-y YEAR') { |v| parmas[:y] = v.to_i }
opt.parse(ARGV)

#今日の日付
today = Date.today

year = parmas[:y] || today.year
month = parmas[:m] || today.month

title = "#{month}月 #{year}"
puts title.center(20)

#日から土を表示する
week = %w(日 月 火 水 木 金 土)
puts week.join(" ")

first_day = Date.new(year, month, 1)
last_day = Date.new(year, month, -1)
fwday = Date.new(year, month, 1).wday     #月の最初の曜日を返す
space = ("   ") * fwday
print space

#カレンダーを表示する

(first_day..last_day).each do |date|
day = sprintf("%2s", date.day) 
  if  date.saturday?
    print "#{day}\n"
  else
    print (day + " ")
  end
end
