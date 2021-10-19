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
