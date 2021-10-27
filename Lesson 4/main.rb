require_relative 'lib/station'
require_relative 'lib/route'
require_relative 'lib/train'
require_relative 'lib/cargo_train'
require_relative 'lib/passenger_train'
require_relative 'lib/wagon'
require_relative 'lib/passenger_wagon'
require_relative 'lib/cargo_train'
require_relative 'lib/console_helper'

stations = []
routes = []
trains = []

loop do
  ConsoleHelper.menu

  user_answer = ConsoleHelper.user_answer
  break if user_answer == '0' || user_answer == 'стоп'

  sub_menu = ConsoleHelper.menu_events(user_answer, {trains: trains, stations: stations, routes: routes})

  if user_answer == '1'
    stations << Station.new(sub_menu)
  elsif user_answer == '2'
    trains << PassengerTrain.new(sub_menu[1]) if sub_menu[0] == '1'
    trains << CargoTrain.new(sub_menu[1]) if sub_menu[0] == '2'
  elsif user_answer == '3'
    routes << Route.new(stations[sub_menu[0].to_i - 1], stations[sub_menu[1].to_i - 1])
  elsif user_answer == '4'
    route = routes[sub_menu[0].to_i - 1]
    if sub_menu[1] == '1'
      route.add_station(stations[sub_menu[2].to_i - 1])
    elsif sub_menu[1] == '2'
      route.delete_station(stations[sub_menu[2].to_i - 1])
    end
  elsif user_answer == '5'
    train = trains[sub_menu[0].to_i - 1]
    route = routes[sub_menu[1].to_i - 1]
    train.set_route(route)
  elsif user_answer == '6'
    train = trains[sub_menu.to_i - 1]
    train.add_wagon(train.type == 'passenger' ? PassengerWagon.new(train) : CargoWagon.new(train))
  elsif user_answer == '7'
    train = trains[sub_menu.to_i - 1]
    train.remove_wagon
  elsif user_answer == '8'
    train = trains[sub_menu[0].to_i - 1]
    sub_menu[1] == '1' ? train.move_forward : move_back
  end

end

