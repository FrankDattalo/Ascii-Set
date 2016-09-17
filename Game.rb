require_relative './Client'

WELCOME_PROMPT = "Welcome to TEMPorary Variable's Game of Set! " +
  " We reccomend you resize your terminal to full screen."
HOST_PROMPT = "Would you like to host or connect? (host / connect): "
IP_PROMPT = "Enter an IP address to connect to (Default: localhost): "
PORT_PROMPT = "Enter a PORT to connect to (Default: 4567): "
NAME_PROMPT = "Enter your name: "
INVALID_PROMPT = "Invalid command, exiting the game"
QUIT_PROMPT = " To quit type 'quit'."

# By trapping CNTRL-C and CNTRL-D throughout our program we prevent two common
# ways people abort programs thus we will force people to quit using the 'quit'
trap 'SIGINT' do
  puts QUIT_PROMPT
end
trap 'SIGQUIT' do
end

clear

puts WELCOME_PROMPT
print HOST_PROMPT
input = gets.chomp

case input
when /\Ahost\Z/i
  exec "ruby API.rb"

when /\Aconnect\Z/i
  print NAME_PROMPT
  PLAYER_NAME = gets.chomp
  
  print IP_PROMPT
  input = gets.chomp
  input = "localhost" if input == ""
  IP = input
  
  print PORT_PROMPT
  input = gets.chomp
  input = "4567" if input == ""
  PORT = input
  
  puts "Attempting to connect to #{IP}:#{PORT} as #{PLAYER_NAME}..."
  CLIENT = Client.new IP, PORT, PLAYER_NAME
  
  CLIENT.start
else
  puts INVALID_PROMPT
end
