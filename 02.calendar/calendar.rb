require "date"
require 'optparse'

opt = OptionParser.new
parmas = {}

opt.on('-m MONTH') { |v| parmas[:m] = v.to_i }
opt.on('-y YEAR') { |v| parmas[:y] = v.to_i }
opt.parse(ARGV)

#今日の日付
today = Date.today

v = parmas[:m]
x = parmas[:y]
if x != nil  #もし年が指定があればその値を、なければ今日の年を返す
  year = parmas[:y]
else
  year = today.year
end

if v != nil           #もし月の指定があればその値を、なければ今日の月を返す
  month = parmas[:m]
else
  month = today.month
end

title = "#{month}月 #{year}"
puts title.center(20)

#日から土を表示する
week = %w(日 月 火 水 木 金 土)
puts week.join(" ")


last_day = Date.new(year, month, -1).day   #月の最後の日を返す
fwday = Date.new(year, month, 1).wday     #月の最初の曜日を返す
space = ("   ") * fwday
print space

#カレンダーを表示する

(1..last_day).each do |date|
monthly_day = Date.new(year, month, date) 
dweek = monthly_day.wday  #1から最後の日までの曜日を返す
dday = date.to_s
day = sprintf("%2s", dday) 
  if dweek == 6
    print "#{day}\n"
  else
    print (day + " ")
  end
end

