puts "Введите имя:"
name = STDIN.gets.chomp

puts "Введите рост:"
height = STDIN.gets.to_f

ideal_weight = (height - 110) * 1.15

puts ideal_weight < 0 ? "Ваш вес уже оптимальный" : "#{name}, ваш идеальный вес: #{ideal_weight.round(2)}"