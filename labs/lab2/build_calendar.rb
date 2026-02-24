require 'date'

if ARGV.length != 4
  puts "Использование: ruby build_calendar.rb teams.txt 01.08.2026 01.06.2027 calendar.txt"
  exit
end
teamsTxt, startDateStr, endDateStr, outputFile = ARGV

begin
  startDate = Date.strptime(startDateStr, "%d.%m.%Y")
  endDate = Date.strptime(endDateStr, "%d.%m.%Y")
rescue
  puts "Ошибка: Неправильный формат даты. Используйте ДД.ММ.ГГГГ"
  exit
end
if startDate > endDate
  puts "Ошибка: Начальная дата не может быть позже конечной"
  exit
end

validDates = []
currentDate = startDate
while currentDate <= endDate
  if [5, 6, 0].include?(currentDate.wday)
    validDates << currentDate
  end
  currentDate += 1
end
if validDates.empty?
  puts "Ошибка: в периоде нет выходных дней"
  exit
end

teams = []
File.foreach(teamsTxt, encoding: 'UTF-8') { |line| teams << line }
if teams.length < 2
  puts "Ошибка: нужно как минимум 2 команды"
  exit
end

teams = teams.reject(&:empty?).map do |line|
  name, city = line.split(' — ', 2)
  { name: name.strip, city: city.strip }
end

games = teams.combination(2).to_a.shuffle

gamesDay = games.length / validDates.length
extra = games.length % validDates.length

File.open(outputFile, 'w') do |file|
  index = 0
  validDates.each_with_index do |day, i|
    count = gamesDay + (i < extra ? 1 : 0)
    (0...count).each do |j|
      t1, t2 = games[index + j]
      time = ["12:00", "15:00", "18:00"][j % 3]
      file.puts "#{day.strftime('%d.%m.%Y')} #{time}: #{t1[:name]} (#{t1[:city]}) vs #{t2[:name]} (#{t2[:city]})"
    end
    index += count
  end
end

puts "Календарь создан! Матчей: #{games.length}, Дней: #{validDates.length}"