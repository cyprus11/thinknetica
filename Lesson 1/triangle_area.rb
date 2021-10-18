puts "Введите основание треугольника:"
a_triangle = STDIN.gets.to_f

puts "Введите высоту треугольника:"
h_triangle = STDIN.gets.to_f

area = 1.0 / 2 * a_triangle * h_triangle

puts "Площадь треугольника: #{area}"