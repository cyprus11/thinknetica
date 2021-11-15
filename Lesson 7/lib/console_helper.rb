class ConsoleHelper

  class << self
    def menu
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
            11. Вывести список вагонов у поезда.
            12. Занять место в вагоне.

            0. выйти
            END
    end

    def menu_events(answer, params)
      case answer
      when '1'
        new_station
      when '2'
        new_train
      when '3'
        new_route(params)
      when '4'
        edit_route(params)
      when '5'
        set_route(params)
      when '6', '7'
        add_remove_wagon(answer, params)
      when '8'
        move_train(params)
      when '9'
        print_stations(params[:stations])
      when '10'
        trains_on_station(params)
      when '11'
        wagons_of_train(params)
      when '12'
        take_wagon_place(params)
      else
        puts 'Такого пункта нет в меню, попытайтесь ещё раз.'
      end
    end

    def user_answer
      gets.chomp
    end

    def print_info(string)
      puts string
    end
  end

  private

  # методы ниже используются только внутри интерфейсов класса, поэтому они приватные
  def self.print_stations(stations)
    unless stations.any?
      puts "Нет станций"
    else
      puts 'Список станций:'
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

  def self.new_station
    puts 'Введите название станции:'
    user_answer
  end

  def self.new_train
    puts <<-END
            Выберите тип поезда:
            1. Пассажирский;
            2. Грузовой
            END
    type = user_answer
    puts 'Введите номер поезда:'
    number = user_answer

    [type, number]
  end

  def self.new_route(params)
    puts 'Укажите начальную и конечную станции(номера, через запятую):'
    return unless print_stations(params[:stations])
    user_answer.split(',').map(&:to_i)
  end

  def self.edit_route(params)
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
  end

  def self.set_route(params)
    puts 'Выберите маршрут и поезд'

    puts 'Маршруты'
    return unless print_routes(params[:routes])
    route = user_answer

    puts 'Поезда'
    return unless print_trains(params[:trains])
    train = user_answer

    [train, route]
  end

  def self.add_remove_wagon(answer, params)
    if answer == '6'
      puts 'Выберите поезд, которому необходимо добавить вагон:'
    elsif answer == '7'
      puts 'Выберите поезд, у которого необходимо отцепить вагон:'
    end

    return unless print_trains(params[:trains])
    train = user_answer

    puts 'Скоько мест в вагоне?'
    places = user_answer

    [train, places]
  end

  def self.move_train(params)
    puts 'Выберите поезд, который необходимо переместить по маршруту:'
    return unless print_trains(params[:trains])
    train = user_answer

    puts '1 - вперед, 2 - назад'
    action = user_answer
    [train, action]
  end

  def self.trains_on_station(params)
    puts 'Выберите станцию:'
    return unless print_stations(params[:stations])
    station = user_answer
<<<<<<< HEAD
    station = params[:stations][station.to_i - 1]
    station.action_with_trains { |train| puts "#{station.trains.index(train) + 1}. #{train.number}" }
=======
    print_trains(params[:stations][station.to_i - 1].trains)
>>>>>>> f1ba4c8e23c710b2e82266258ffd92c6f9854bf0
  end

  def self.wagons_of_train(params)
    if params[:trains].any?
      puts 'Выберите поезд:'
      print_trains(params[:trains])
      train = params[:trains][user_answer.to_i - 1]
      puts 'Вагоны:'
      train.action_with_wagons{ |wagon| puts wagon}
    else
      puts 'Создайте хотя бы один поезд'
    end
  end

  def self.take_wagon_place(params)
    if params[:trains].any?
      puts 'Выберите поезд:'
      print_trains(params[:trains])
      train = params[:trains][user_answer.to_i - 1]
      puts 'Выберите вагон:'
      train.action_with_wagons{ |wagon| puts "#{train.wagons.index(wagon) + 1}. #{wagon}"}
      wagon = train.wagons[user_answer.to_i - 1]
      places_count = if wagon.is_passenger?
                        0
                      else
                        puts 'Сколько места необходимо занять?'
                        user_answer.to_i
                      end

      [wagon, places_count]
    else
      puts 'Создайте хотя бы один поезд'
    end
  end
end