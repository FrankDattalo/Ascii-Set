require_relative './Client'
require 'json'

TIME_BETWEEN_POLLS_IN_SECONDS = 5
PROMPT = "Commands: (/reset), (/start), (/set <c1>, <c2>, <c3>), (/stuck), (/quit), (/help)"
SEPARATOR = '-----------------------------------------------------------------------------------------------'
continue_playing = true

print "Enter an ip address to connect to: "
IP = gets.chomp

print "Enter a port to connect to: "
PORT = gets.chomp

print "Enter your name: "
PLAYER_NAME = gets.chomp

puts "Attempting to connect..."

CLIENT = Client.new IP, PORT, PLAYER_NAME

# if our connection has been accepted, play
if JSON.parse(CLIENT.connect)['accepted']
	puts "Connected Successfully!"

	# the loop that runs in this thread is dedicated to printing game updates to the console
	game_display_loop_thread = Thread.new do

		# by having a cached set of cards we can prevent the console from
		# being flooded by the same cards over and over while
		# also ensuring that what we are seeing on our screen
		# is at most TIME_BETWEEN_POLLS_IN_SECONDS seconds old
		cached_data = nil

		while true
			data = JSON.parse(CLIENT.get_data)

			# if we are playing and our cache is != the current cards, display info
			if data['started'] && data != cached_data
				puts SEPARATOR
				puts data['cards'] # TODO: Print Cards, And Other Game Data Here
				puts PROMPT
				cached_data = data # update cached_data to be what we just saw
			end
			sleep TIME_BETWEEN_POLLS_IN_SECONDS
		end
	end

	puts PROMPT
	while continue_playing
		input = gets.chomp

		case input
		when /set [a-z], [a-z], [a-z]/i # check to see if the input is a set

			# parses the input into an array
			split = input.split(/,| /).delete_if { |entry| entry == ""}

			#the indecies of cards within the set (a..z)
			is_set = JSON.parse(CLIENT.is_set? split[1], split[2], split[3])['is_set']

			if is_set
				puts "You found a set! :D"
			else
				puts "Sorry! That wasn't a set. :("
			end

		when /start/i # send start signal

			# we will only continue to play the game if the sever responds with
			# 	game_playable = true
			continue_playing = JSON.parse(CLIENT.start_game)['game_playable']
			if continue_playing
				puts "Game is starting!"
			else
				puts "Could not start game!"
			end

		when /help/i # print list of commands on /help
			puts PROMPT

		when /stuck/i # send stuck signal to server
			puts CLIENT.stuck

		when /reset/i # reset game on /reset command
			puts 'Resetting Game...'
			CLIENT.new_game

			unless JSON.parse(CLIENT.connect)['accepted'] # re-register name
				puts 'Could not re-register name after game reset'
				continue_playing = false # if we failed to re-register, exit
			else
				puts "Reset Successfully. Playing as #{PLAYER_NAME}"
			end

		when /quit/i #quit game on /quit command
			continue_playing = false

		else # Display Error Message On Invalid Command
			puts "ERROR #{input} IS INVALID -> #{PROMPT}"
		end
	end

	# kill printing thread, we dont need where we're going
	game_display_loop_thread.kill

else
	puts "Could not connect!" # ruh roh spaghettios
end

puts "Bye!" # Felicia
