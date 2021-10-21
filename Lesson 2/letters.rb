# Заполнить хеш гласными буквами, где значением будет являтся порядковый
# номер буквы в алфавите

vowels = %w(a e i o u)
letters = ('a'..'z').to_a
result_hash = {}

letters.each.with_index(1) do |letter, index|
  result_hash[letter] = index if vowels.include?(letter)
end
