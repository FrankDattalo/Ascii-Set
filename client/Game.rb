require_relative './Client'

PROMPT = "Commands: (reset), (start), (set <c1> <c2> <c3>), (stuck), (quit), (players), (help)"
continue_playing = true

clear

print "Enter an ip address to connect to: "
IP = gets.chomp

print "Enter a port to connect to: "
PORT = gets.chomp

print "Enter your name: "
PLAYER_NAME = gets.chomp

clear

puts "Attempting to connect..."

CLIENT = Client.new IP, PORT, PLAYER_NAME

# if our connection has been accepted, play
if CLIENT.connect
	puts "Connected Successfully! Type 'start' to start the game."

	CLIENT.start_game_print_thread

	while continue_playing
		input = gets.chomp

		case input
		when /players/i
			CLIENT.print_players

		when /set [a-z] [a-z] [a-z]/i # check to see if the input is a set

			# parses the input into an array
			split = input.split

			#the indecies of cards within the set (a..z)
			if CLIENT.is_set? split[1], split[2], split[3]

				puts "You found a set! :D"
			else
				puts "Sorry! That wasn't a set. :("
			end

		when /start/i # send start signal

			# we will only continue to play the game if the sever responds with
			# 	game_playable = true
			continue_playing = CLIENT.start_game

			if continue_playing
				puts "Game is starting!"
			else
				puts "Could not start game!"
			end

		when /help/i # print list of commands on /help
			puts PROMPT

		when /stuck/i # send stuck signal to server
			CLIENT.stuck

		when /reset/i # reset game on /reset command
			clear
			puts 'Resetting Game...'
			CLIENT.new_game
			unless CLIENT.connect # re-register name
				puts 'Could not re-register name after game reset'
				continue_playing = false # if we failed to re-register, exit
			else
				puts "Reset Successfully. Playing as #{PLAYER_NAME}. Type 'start' to start the game."
			end

		when /quit/i #quit game on /quit command

			CLIENT.un_register_name # free player's name from server
			continue_playing = false

		else # Display Error Message On Invalid Command
			puts "ERROR #{input} IS INVALID -> #{PROMPT}"
		end
	end

	CLIENT.end_game_print_thread
	clear
	CLIENT.print_scores

else
	puts "Could not connect! Game may be in progress, name may be taken, or the IP is invalid." # ruh roh spaghettios
end

puts "Bye!" # Felicia
