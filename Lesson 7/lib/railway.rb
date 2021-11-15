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
    when '12'
      take_a_place(sub_menu)
    end
  end

  private

  # Данные методы приватные, т.к. используются внутри данного класса
  def create_station(station_name)
    stations << Station.new(station_name)
  end

  def create_train(sub_menu)
    new_train = nil
    flag = true
    begin
      unless flag
        ConsoleHelper.print_info('Введите корректное значение.')
        sub_menu[1] = ConsoleHelper.user_answer
        flag = true
      end

      case sub_menu[0]
      when '1'
        new_train = PassengerTrain.new(sub_menu[1])
      when '2'
        new_train = CargoTrain.new(sub_menu[1])
      end
    rescue RuntimeError => e
      ConsoleHelper.print_info(e.message)
      flag = false
      retry
    end

    ConsoleHelper.print_info("#{new_train} создан.")
    trains << new_train
  end

  def create_route(sub_menu)
    sub_menu.size < 2 ? (ConsoleHelper.print_info("Недостаточно станций, создайте ещё")) :
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
    train = trains[sub_menu[0].to_i - 1]
    train.add_wagon(train.type == 'passenger' ? PassengerWagon.new(train, sub_menu[1].to_i) : CargoWagon.new(train, sub_menu[1].to_i))
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
end