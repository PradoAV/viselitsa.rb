# encoding: utf-8
#
# Этот код необходим только при использовании русских букв на Windows
if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end


# запускаем программу. Удобно!
require_relative 'viselitsa_methods'

# -------------------- Начало основной логики программы --------------------

# Сначала очистим экран, чтобы не видно было загаданное слово
cls

puts "Игра виселица. Версия 1. (с) \n\n"
sleep 1

# Создадим массив букв загаданного слова. «Взятием» букв у нас будет заниматься
# метод get_letters. Он будет возвращать массив из букв загаданного слова.
letters = get_letters

# Объявим переменную errors, которая будет хранить текущее значение количества
# ошибок, которое совершил пользователь. Начальное значение, очевидно, 0.
errors = 0

# Объявим два массива (для правильно отгаданных букв и для букв, которых нет в
# загаданном слове). Каждая попытка пользователя будет попадать в один из этих
# массивов.
good_letters = []
bad_letters = []

# Основной цикл программы, в котором спрашиваем у пользователя букву и обновляем
# все переменные в зависимости от его ответа. Всего у пользователя есть 7
# осечек, чтобы успеть отгадать слово. Поэтому игра продолжается, пока
# количество ошибок меньше 7.
while errors < 7

  print_status(letters, good_letters, bad_letters, errors)

  puts "\nВведите следующую букву"
  user_input = get_user_input

  # Проверяем введенную букву специальным методом check_input, которому тоже для
  # работы нужно знать все о состоянии игры: что ввел пользователь, какие буквы
  # есть в слове и какие буквы пользователь уже пробовал.
  result = check_input(user_input, letters, good_letters, bad_letters)

  # В зависимости от того, что вернул нам метод check_input, мы принимаем одно
  # из решений:
  if result == -1
    # Если метод вернул -1, значит буква не угадана: увеличиваем счетчик ошибок
    errors += 1
  elsif result == 1
    # Если результат равен 1, значит пользователь угадал всё слово и пора
    # зукругляться — прерываем цикл.
    break
  end
  # Если check_result вернул нам 0, значит игра продолжается, мы ничего не
  # делаем, а просто запускаем тело цикла снова.
end

# выводим напоследок результат игры
print_status(letters, good_letters, bad_letters, errors)