# frozen_string_literal: true

module ConsoleHelper
  class << self
    MENU = {
      '1': 'Создать станцию.',
      '2': 'Создать поезд.',
      '3': 'Создать маршрут.',
      '4': 'Управление маршрутом.',
      '5': 'Назначить маршрут поезду.',
      '6': 'Добавить вагон поезду.',
      '7': 'Отцепить вагон от поезда.',
      '8': 'Перемещение поезда по маршруту.',
      '9': 'Просмотреть список станций.',
      '10': 'Просмотреть список поездов на станции.',
      '11': 'Вывести список вагонов у поезда.',
      '12': 'Занять место в вагоне.',
      '0': 'Выйти'
    }.freeze

    MENU_ACTIONS = {
      '1': proc { |object| object.send(:new_station) },
      '2': proc { |object| object.send(:new_train) },
      '3': proc { |object, params| object.send(:new_route, params) },
      '4': proc { |object, params| object.send(:edit_route, params) },
      '5': proc { |object, params| object.send(:route, params) },
      '6': proc { |object, params, answer| object.send(:add_remove_wagon, params, answer) },
      '7': proc { |object, params, answer| object.send(:add_remove_wagon, params, answer) },
      '8': proc { |object, params| object.send(:move_train, params) },
      '9': proc { |object, params| object.send(:print_stations, params) },
      '10': proc { |object, params| object.send(:trains_on_station, params) },
      '11': proc { |object, params| object.send(:wagons_of_train, params) },
      '12': proc { |object, params| object.send(:take_wagon_place, params) }
    }.freeze

    def menu
      puts '============МЕНЮ============'
      MENU.each do |k, v|
        puts "#{k}. #{v}"
      end
    end

    def menu_events(answer, params)
      if MENU_ACTIONS.keys.include?(answer.to_sym)
        MENU_ACTIONS[answer.to_sym].call(ConsoleHelper, params, answer)
      else
        puts 'Такого пункта нет в меню, попытайтесь ещё раз.'
      end
    end

    def user_answer
      gets.chomp
    end

    def user_answer_as_index
      user_answer.to_i - 1
    end

    def print_info(string)
      puts string
    end
  end

  # методы ниже используются только внутри интерфейсов класса, поэтому они приватные
  def self.print_stations(params)
    stations = params[:stations]
    if stations.any?
      puts 'Список станций:'
      stations.each.with_index(1) { |station, index| puts "#{index}. #{station.name}" }
      true
    else
      puts 'Нет станций'
    end
  end

  def self.print_routes(routes)
    if routes.any?
      routes.each.with_index(1) { |route, index| puts "#{index}. #{route.all_stations.map(&:name).join(', ')}" }
      true
    else
      puts 'Нет маршрутов'
    end
  end

  def self.print_trains(trains)
    if trains.any?
      trains.each.with_index(1) { |train, index| puts "#{index}. #{train.number}" }
      true
    else
      puts 'Нет поездов'
    end
  end

  def self.new_station
    puts 'Введите название станции:'
    user_answer
  end

  def self.new_train
    puts 'Выберите тип поезда:'
    puts '1. Пассажирский;'
    puts '2. Грузовой'

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
    puts '1. Добавить станцию.'
    puts '2. Удалить станцию.'

    action_with_route = user_answer

    return unless print_stations(params[:stations])

    new_station = user_answer

    [route, action_with_route, new_station]
  end

  def self.route(params)
    puts 'Выберите маршрут и поезд'

    puts 'Маршруты'
    return unless print_routes(params[:routes])

    route = user_answer

    puts 'Поезда'
    return unless print_trains(params[:trains])

    train = user_answer

    [train, route]
  end

  def self.add_remove_wagon(params, answer)
    puts 'Выберите поезд, которому необходимо добавить вагон:' if answer == '6'
    puts 'Выберите поезд, у которого необходимо отцепить вагон:' if answer == '7'

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
    station = params[:stations][station.to_i - 1]
    station.action_with_trains { |train| puts "#{station.trains.index(train) + 1}. #{train.number}" }
  end

  def self.wagons_of_train(params)
    if params[:trains].any?
      puts 'Выберите поезд:'
      print_trains(params[:trains])
      train = params[:trains][user_answer_as_index]
      puts 'Вагоны:'
      train.action_with_wagons { |wagon| puts wagon }
    else
      puts 'Создайте хотя бы один поезд'
    end
  end

  def self.take_wagon_place(params)
    trains = params[:trains]

    if trains.any?
      choose_wagon_and_places_count(trains)
    else
      puts 'Создайте хотя бы один поезд'
    end
  end

  def self.choose_wagon_and_places_count(trains)
    puts 'Выберите поезд:'
    print_trains(trains)
    train_index = user_answer_as_index
    train = trains[train_index]
    puts 'Выберите вагон:'
    train.action_with_wagons { |wagon| puts "#{train.wagons.index(wagon) + 1}. #{wagon}" }
    wagon_index = user_answer_as_index
    wagon = train.wagons[wagon_index]
    places_count = place_count(wagon)
    [wagon, places_count]
  end

  def self.places_count(wagon)
    return 0 if wagon.passenger?

    puts 'Сколько места необходимо занять?'
    user_answer.to_i
  end
end
