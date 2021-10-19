# Прямоугольный треугольник. Программа запрашивает у пользователя 3 стороны треугольника и
# определяет, является ли треугольник прямоугольным (используя теорему Пифагора www-formula.ru),
# равнобедренным (т.е. у него равны любые 2 стороны)  или равносторонним (все 3 стороны равны)
# и выводит результат на экран. Подсказка: чтобы воспользоваться теоремой Пифагора, нужно
# сначала найти самую длинную сторону (гипотенуза) и сравнить ее значение в квадрате с суммой
# квадратов двух остальных сторон. Если все 3 стороны равны, то треугольник равнобедренный и
# равносторонний, но не прямоугольный.

def pifagor(triangle_sizes)
  if triangle_sizes.uniq.size == 1
    "Треугольник является равнобедренным и равносторонним."
  else
    max_length = triangle_sizes.delete(triangle_sizes.max)

    if max_length ** 2 == triangle_sizes.map {|size| size ** 2}.sum
      "Треугольник является прямоугольным."
    else
      "Треугольник не является ни прямоугольным, ни равносторонним."
    end
  end
end

triangle_sizes = []

3.times do |i|
  puts "Введите значение длины #{i + 1} стороны:"
  triangle_sizes << STDIN.gets.to_f
end

puts pifagor(triangle_sizes)
