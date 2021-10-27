class ConsoleHelper
  def self.menu
    puts <<-END

          ============МЕНЮ============
          1. Создать станцию.
          2. Создать поезд.
          3. Создать маршрут.
          4. Управление маршрутом.
          5. Назначить маршрут поезду.
          6. Добавить вагон поезду.
          7. Отцепить вагон от поезда.
          8. Перемещение поезда по маршруту.
          9. Просмотреть список станций.
          10. Просмотреть список поездов на станции.

          0. выйти
          END
  end

  def self.menu_events(answer, params)
    case answer
    when '1'
      puts 'Введите название станции:'
      user_answer
    when '2'
      puts <<-END
            Выберите тип поезда:
            1. Пассажирский;
            2. Грузовой
            END
      type = user_answer
      puts 'Введите номер поезда:'
      number = user_answer

      [type, number]
    when '3'
      puts 'Укажите начальную и конечную станции(номера, через запятую):'
      return unless print_stations(params[:stations])
      stations = user_answer.split(',').map(&:to_i)
      return if stations.size < 2
      stations
    when '4'
      puts 'Выберите каким марщрутом управлять?'
      return unless print_routes(params[:routes])
      route = user_answer
      puts <<-END
            1. Добавить станцию.
            2. Удалить станцию.
            END
      action_with_route = user_answer

      return unless print_stations(params[:stations])
      new_station = user_answer

      [route, action_with_route, new_station]
    when '5'
      puts 'Выберите маршрут и поезд'
      puts 'Маршруты'
      return unless print_routes(params[:routes])
      route = user_answer
      puts 'Поезда'
      return unless print_trains(params[:trains])
      train = user_answer
      [train, route]
    when '6'
      puts 'Выберите поезд, которому необходимо добавить вагон:'
      return unless print_trains(params[:trains])
      train = user_answer
    when '7'
      puts 'Выберите поезд, у которого необходимо отцепить вагон:'
      return unless print_trains(params[:trains])
      train = user_answer
    when '8'
      puts 'Выберите поезд, который необходимо переместить по маршруту:'
      return unless print_trains(params[:trains])
      train = user_answer
      puts '1 - вперед, 2 - назад'
      action = user_answer
      [train, action]
    when '9'
      puts 'Список станций:'
      print_stations(params[:stations])
    when '10'
      puts 'Выберите станцию:'
      return unless print_stations(params[:stations])
      station = user_answer
      print_trains(params[:stations][station.to_i - 1].trains)
    else
      puts 'Такого пункта нет в меню, попытайтесь ещё раз.'
    end
  end

  def self.user_answer
    gets.chomp
  end

  def self.print_stations(stations)
    unless stations.any?
      puts "Нет станций"
    else
      stations.each.with_index(1) { |station, index| puts "#{index}. #{station.name}" }
      true
    end
  end

  def self.print_routes(routes)
    unless routes.any?
      puts "Нет маршрутов"
    else
      routes.each.with_index(1) { |route, index| puts "#{index}. #{route.all_stations.map(&:name).join(", ")}" }
      true
    end
  end

  def self.print_trains(trains)
    unless trains.any?
      puts "Нет поездов"
    else
      trains.each.with_index(1) { |train, index| puts "#{index}. #{train.number}" }
      true
    end
  end
end