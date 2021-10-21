# Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя).
# Найти порядковый номер даты, начиная отсчет с начала года.
# Учесть, что год может быть високосным.


def leap_year?(year)
  return true if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
  false
end

months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

puts "Введите день:"
day = gets.to_i

puts "Введите номер месяца:"
month = gets.to_i

puts "Введите год(YYYY):"
year = gets.to_i

months[1] = 29 if leap_year?(year)

if (day <= 0 && day > months[month - 1]) || !(1..12).include?(month) || year < 0
  puts "Недопустимая дата"
elsif month == 1
  puts "Порядковый номер даты: #{day}"
else
  (1...month).each do |i|
    day += months[i - 1]
  end
  puts "Порядковый номер даты: #{day}"
end
