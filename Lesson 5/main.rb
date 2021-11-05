require_relative 'lib/instance_counter'
require_relative 'lib/train_wagon_methods'
require_relative 'lib/station'
require_relative 'lib/route'
require_relative 'lib/train'
require_relative 'lib/cargo_train'
require_relative 'lib/passenger_train'
require_relative 'lib/wagon'
require_relative 'lib/passenger_wagon'
require_relative 'lib/cargo_train'
require_relative 'lib/console_helper'
require_relative 'lib/railway'


# railway = Railway.new

# loop do
#   ConsoleHelper.menu

#   user_answer = ConsoleHelper.user_answer
#   break if user_answer == '0' || user_answer == 'стоп'

#   sub_menu = ConsoleHelper.menu_events(user_answer, {trains: railway.trains, stations: railway.stations, routes: railway.routes})

#   railway.action_with_railway(user_answer, sub_menu)
# end
