class Railway
  attr_reader :trains, :stations, :routes

  def initialize
    @trains = []
    @stations = []
    @routes = []
  end

  def action_with_railway(user_input, sub_menu)
    case user_input
    when '1'
      create_station(sub_menu)
    when '2'
      create_train(sub_menu)
    when '3'
      create_route(sub_menu)
    when '4'
      manage_route(sub_menu)
    when '5'
      set_route_to_train(sub_menu)
    when '6'
      add_wagon_to_train(sub_menu)
    when '7'
      remove_train_wagon(sub_menu)
    when '8'
      move_train(sub_menu)
    end
  end

  private

  # Данные методы приватные, т.к. используются внутри данного класса
  def create_station(station_name)
    stations << Station.new(station_name)
  end

  def create_train(sub_menu)
    trains << PassengerTrain.new(sub_menu[1]) if sub_menu[0] == '1'
    trains << CargoTrain.new(sub_menu[1]) if sub_menu[0] == '2'
  end

  def create_route(sub_menu)
    sub_menu.size < 2 ? (puts "Недостаточно станций, создайте ещё") :
      routes << Route.new(stations[sub_menu[0].to_i - 1], stations[sub_menu[1].to_i - 1])
  end

  def manage_route(sub_menu)
    route = routes[sub_menu[0].to_i - 1]
    if sub_menu[1] == '1'
      route.add_station(stations[sub_menu[2].to_i - 1])
    elsif sub_menu[1] == '2'
      route.delete_station(stations[sub_menu[2].to_i - 1])
    end
  end

  def set_route_to_train(sub_menu)
    train = trains[sub_menu[0].to_i - 1]
    route = routes[sub_menu[1].to_i - 1]
    train.set_route(route)
  end

  def add_wagon_to_train(sub_menu)
    train = trains[sub_menu.to_i - 1]
    train.add_wagon(train.type == 'passenger' ? PassengerWagon.new(train) : CargoWagon.new(train))
  end

  def remove_train_wagon(sub_menu)
    train = trains[sub_menu.to_i - 1]
    train.remove_wagon
  end

  def move_train(sub_menu)
    train = trains[sub_menu[0].to_i - 1]
    sub_menu[1] == '1' ? train.move_forward : train.move_back
  end
end