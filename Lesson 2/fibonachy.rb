# Заполнить массив числами фибоначчи до 100

array = [0, 1]

100.times do
  array << (array[-2] + array[-1])
end
