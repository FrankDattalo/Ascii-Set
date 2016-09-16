require_relative './Client'

HOST_PROMPT = "Would you like to host or connect? (host / connect): "
IP_PROMPT = "Enter an IP address to connect to (Default: localhost): "
PORT_PROMPT = "Enter a PORT to connect to (Default: 4567): "
NAME_PROMPT = "Enter your name: "
INVALID_PROMPT = "Invalid command, exiting the game"

clear

print HOST_PROMPT
input = gets.chomp

case input
when /host/i
	exec "ruby API.rb"

when /connect/i
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

	clear

	puts "Attempting to connect to #{IP}:#{PORT} as #{PLAYER_NAME}..."

	CLIENT = Client.new IP, PORT, PLAYER_NAME

	CLIENT.start
else
	puts INVALID_PROMPT
end
