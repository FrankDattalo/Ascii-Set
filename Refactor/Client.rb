require 'rest-client'
require 'json'
require_relative './Card'

PROMPT = "Commands: (reset), (start), (set <c1> <c2> <c3>), (stuck), (quit), (players), (help)"
SEPARATOR = '-----------------------------------------------------------------------------------------------'
SECONDS_BETWEEN_POLLS = 1

def clear
	begin
		system 'clear' or system 'cls'
	rescue
		puts 'could not clear screen'
	end
end

class Client

	attr_accessor :ip_address, :port

	def initialize(ip_address, port, name)
		@ip_address = ip_address
		@port = port
		@player_name = name
		@game_print_thread = nil
		@continue_playing = true
	end

	def connect
			JSON.parse(get '/auth?name=' + @player_name)['accepted']
	end

	def get_data
			JSON.parse(get '/deck')
	end

	def new_game
			get '/new'
	end

	def un_register_name
		get '/un-register?name=' + @player_name
	end

	def start_game
			JSON.parse(get('/start'))['game_playable']
	end

	def is_set?(cardIndex1, cardIndex2, cardIndex3)
		JSON.parse(get('/check-set?name=' + @player_name +
								'&card1=' + cardIndex1 +
								'&card2=' + cardIndex2 +
								'&card3=' + cardIndex3))['is_set']
	end

	def print_players
		players = "Current Players: "
		JSON.parse(self.players)['players'].each do |player|
			players += "#{player['name']} "
		end
		puts players
	end

	def print_scores
		printf("%-3s %-15s %6s\n", '#', "Names", "Scores")
		i = 1
		JSON.parse(self.players)['players'].each do |player|
			printf("%-3d %-15s %6s\n", i, player['name'], player['score'])
			i += 1
		end
	end

	def print_game_data(hash_of_data)

		puts SEPARATOR

		hash_of_data['cards'].each do |index, card|
			#number, color, shape, texture
			c = Card.new(card['number'], card['color'].to_sym, card['shape'].to_sym, card['texture'].to_sym)
			puts c
			puts index
		end

		puts SEPARATOR

		puts "Cards Remaining: #{hash_of_data['cards_left'] + 12}"

		puts SEPARATOR

		self.print_scores

		puts SEPARATOR

		hints = "Hints:"
		hash_of_data['hints'].each do |h|
			hints += " #{h}"
		end
		puts hints

		puts SEPARATOR

	end

	def stuck
		get '/stuck'
	end

	def start
		puts PROMPT

		if self.connect
			puts "Connected Successfully! Type 'start' to start the game."

			self.start_game_print_thread
			self.input_loop
			self.end_game_print_thread

			self.un_register_name # free player's name from server
			puts 'Bye!'

		else
			puts "Could not connect! Game may be in progress, name may be taken, or the IP is invalid. Game will now exit."
		end
	end

	def players
		get '/players'
	end

	def start_game_print_thread
		@game_print_thread = Thread.new do
			cached_data = nil

			loop do
				data = self.get_data

				if data['started'] && data != cached_data

					if data['game_over']
						@continue_playing = false

						puts "Game Over! Deck is empty or there are no more sets!"
						CLIENT.print_scores

					else
						clear
						self.print_game_data data
					end

				elsif data != cached_data
					self.print_players
				end

				cached_data = data

				sleep SECONDS_BETWEEN_POLLS

			end
		end
	end

	def input_loop
		@continue_playing = true

		while @continue_playing
			input = gets.chomp

			if @continue_playing then
				case input
				when /players/i
					self.print_players

				when /set [a-z] [a-z] [a-z]/i

					split = input.split

					if self.is_set? split[1], split[2], split[3]
						puts "You found a set! :D"
					else
						puts "Sorry! That wasn't a set. :("
					end

				when /start/i
					if self.start_game then
						puts "Game is starting!"
					else
						puts "Could not start game! Type 'quit' to quit."
					end

				when /help/i # print list of commands on /help
					puts PROMPT

				when /stuck/i # send stuck signal to server
					self.stuck

				when /reset/i # reset game on /reset command
					clear
					puts 'Resetting Game...'
					self.new_game

					if self.connect then
						puts "Reset Successfully. Playing as #{@player_name}. Type 'start' to start the game."
					else
						puts "Could not re-register name after game reset. Type 'quit' to quit"
					end

				when /quit/i #quit game on /quit command
					@continue_playing = false

				else # Display Error Message On Invalid Command
					puts "ERROR #{input} IS INVALID -> #{PROMPT}"
				end
			end
		end
	end

	def end_game_print_thread
		@game_print_thread.kill
	end

	private def get(url_after_slash)
			RestClient.get full_name + url_after_slash
	end

	private def full_name
		"http://#{@ip_address}:#{@port}"
	end
end
