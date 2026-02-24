require 'date'

startDateStr, endDateStr, outputFile = ARGV[1..]

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

allTeams = []
File.foreach('teams.txt', encoding: 'UTF-8') { |line|
  allTeams << line
  allTeams << line
}
allTeams.shuffle!

matches = []
i = 0
while i < allTeams.length - 1
  team1 = allTeams[i]
  team2 = allTeams[i + 1]
  
  if team1 != team2
    matches << [team1, team2]
    i += 2
  else
    i += 1
  end
end

calendar = []
currentMatch = 0
validDates.each do |date|
  [12, 15, 18].each do |hour|
    for i in 0..1
      if currentMatch < matches.length
        calendar << [date, hour, matches[currentMatch]]
        currentMatch += 1
      end
    end
  end
end

File.open(outputFile, 'w:UTF-8') do |file|
  calendar.each do |item|
    date, hour, match = item
    file.puts "#{date.strftime('%d.%m.%Y')} #{hour}:00: #{match[0]} vs #{match[1]}"
  end
end