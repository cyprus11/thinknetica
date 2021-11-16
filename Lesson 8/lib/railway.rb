# frozen_string_literal: true

class Railway
  ACTIONS = {
    '1': proc { |railway, sub_menu| railway.send(:create_station, sub_menu) },
    '2': proc { |railway, sub_menu| railway.send(:create_train, sub_menu) },
    '3': proc { |railway, sub_menu| railway.send(:create_route, sub_menu) },
    '4': proc { |railway, sub_menu| railway.send(:manage_route, sub_menu) },
    '5': proc { |railway, sub_menu| railway.send(:route_to_train, sub_menu) },
    '6': proc { |railway, sub_menu| railway.send(:add_wagon_to_train, sub_menu) },
    '7': proc { |railway, sub_menu| railway.send(:remove_train_wagon, sub_menu) },
    '8': proc { |railway, sub_menu| railway.send(:move_train, sub_menu) },
    '12': proc { |railway, sub_menu| railway.send(:take_a_place, sub_menu) }
  }.freeze

  attr_reader :trains, :stations, :routes

  def initialize
    @trains = []
    @stations = []
    @routes = []
  end

  def action_with_railway(user_input, sub_menu)
    ACTIONS[user_input.to_sym].call(self, sub_menu) if ACTIONS.keys.include?(user_input.to_sym)
  end

  private

  # Данные методы приватные, т.к. используются внутри данного класса
  def create_station(station_name)
    stations << Station.new(station_name)
  end

  def create_train(sub_menu)
    new_train, flag = nil, true
    begin
      sub_menu[1], flag = change_flag_true unless flag
      new_train = new_train(sub_menu[1], sub_menu[0])
    rescue RuntimeError => e
      ConsoleHelper.print_info(e.message)
      flag = false
      retry
    end
    ConsoleHelper.print_info("#{new_train} создан.")
    trains << new_train
  end

  def create_route(sub_menu)
    if sub_menu.size < 2
      ConsoleHelper.print_info('Недостаточно станций, создайте ещё')
    else
      routes << Route.new(stations[sub_menu[0].to_i - 1], stations[sub_menu[1].to_i - 1])
    end
  end

  def manage_route(sub_menu)
    route = routes[sub_menu[0].to_i - 1]

    station_index = sub_menu[2].to_i - 1

    route.add_station(stations[station_index]) if sub_menu[1] == '1'
    route.delete_station(stations[station_index]) if sub_menu[1] == '2'
  end

  def route_to_train(sub_menu)
    train = trains[sub_menu[0].to_i - 1]
    route = routes[sub_menu[1].to_i - 1]
    train.route(route)
  end

  def add_wagon_to_train(sub_menu)
    train = trains[sub_menu[0].to_i - 1]
    train.add_wagon(if train.type == 'passenger'
                      PassengerWagon.new(train,
                                         sub_menu[1].to_i)
                    else
                      CargoWagon.new(train,
                                     sub_menu[1].to_i)
                    end)
  end

  def remove_train_wagon(sub_menu)
    train = trains[sub_menu.to_i - 1]
    train.remove_wagon
  end

  def move_train(sub_menu)
    train = trains[sub_menu[0].to_i - 1]
    sub_menu[1] == '1' ? train.move_forward : train.move_back
  end

  def take_a_place(sub_menu)
    wagon = sub_menu[0]
    wagon.take_a_place(sub_menu[1])
  end

  def change_flag_true
    ConsoleHelper.print_info('Введите корректное значение.')

    [ConsoleHelper.user_answer, true]
  end

  def new_train(type, value)
    return PassengerTrain.new(type) if value == '1'

    CargoTrain.new(type)
  end
end
