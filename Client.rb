require 'rest-client'
require 'json'
require_relative './Card'

PROMPT = "Commands: (start), (set <c1> <c2> <c3>), (stuck), (quit), (players), (help)"
DEBUG_PROMPT = "DEBUG Commands: (start), (new), (set <c1> <c2> <c3>), (stuck), (quit), (players), (help)"
NEWLINES = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
SEPARATOR = '------------------------------------------------------------------------------------------------------------------------'
SECONDS_BETWEEN_POLLS = 1
SPACE_BETWEEN_CARDS = "    "
HALF_CARD = "             "
# Sys call to clear the screen so that  the game is not constantly scrolling
def clear
	print NEWLINES
	begin
		system 'clear' or system 'cls'
	rescue
		puts 'could not clear screen'
	end
end

#Defines what a client can do
#clients can:
# Connect to a server, get data from a server, start a new game, leave the game,
# start a game, ask the server if there is a set, print game data, ect.
# all of the actual meaty game logic exists on the server in Server.rb and API.rb
class Client

	attr_accessor :ip_address, :port

	def initialize(ip_address, port, name, debug = false)
		@ip_address = ip_address
		@port = port
		@player_name = name
		@game_print_thread = nil
		@continue_playing = true
		@debug = debug
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

  #makes a network cal to get players with self.players than prints player related information
  #JSON.parse returns a hash map which we access each player with
	def print_players
		players = "Current Players: "
		JSON.parse(self.players)['players'].each do |player|
			players += "(#{player['name']}) "
		end
		puts players
  end

	def print_scores(players)
		printf("%-3s %-30s %6s\n", '#', "Names", "Scores")
		i = 1
		players.each do |player|
			printf("%-3d %-30s %6s\n", i, player['name'], player['score'])
			i += 1
		end
	end

	#this just prints the screen you see when you play the game. It's lots of complicated logic but it works.
  #this is pulling data from the hash which is populated by server data
	def print_game_data(hash_of_data)

		puts "Playing As: #{@player_name}"

		card_array = []

		hash_of_data['cards'].each do |index, card|
			card_array << {
				index: index,
				card: Card.new(card['number'],
					card['color'].to_sym,
					card['shape'].to_sym,
					card['texture'].to_sym)
				}
		end

		card_array.sort! do |a, b|
			a[:index] <=> b[:index]
		end

		cards_to_print = []
		while card_array.any?
			cards_to_print << card_array.shift
			if cards_to_print.size == 4 then
				#print four cards
				13.times do |i|
					puts "#{cards_to_print[0][:card].get_row_string(i + 1)}" +
						"#{SPACE_BETWEEN_CARDS}#{cards_to_print[1][:card].get_row_string(i + 1)}" +
						"#{SPACE_BETWEEN_CARDS}#{cards_to_print[2][:card].get_row_string(i + 1)}" +
						"#{SPACE_BETWEEN_CARDS}#{cards_to_print[3][:card].get_row_string(i + 1)}"
				end
				puts "#{HALF_CARD}#{cards_to_print[0][:index]}#{HALF_CARD}" +
					"#{SPACE_BETWEEN_CARDS}#{HALF_CARD}#{cards_to_print[1][:index]}#{HALF_CARD}" +
					"#{SPACE_BETWEEN_CARDS}#{HALF_CARD}#{cards_to_print[2][:index]}#{HALF_CARD}" +
					"#{SPACE_BETWEEN_CARDS}#{HALF_CARD}#{cards_to_print[3][:index]}#{HALF_CARD}"
				cards_to_print = []
			end
		end

		if cards_to_print.any? then
			case cards_to_print.size
			when 1
				13.times do |i|
					puts "#{cards_to_print[0][:card].get_row_string(i + 1)}"
				end
				puts "#{HALF_CARD}#{cards_to_print[0][:index]}#{HALF_CARD}"
			when 2
				13.times do |i|
					puts "#{cards_to_print[0][:card].get_row_string(i + 1)}" +
						"#{SPACE_BETWEEN_CARDS}#{cards_to_print[1][:card].get_row_string(i + 1)}"
				end
				puts "#{HALF_CARD}#{cards_to_print[0][:index]}#{HALF_CARD}" +
					"#{SPACE_BETWEEN_CARDS}#{HALF_CARD}#{cards_to_print[1][:index]}#{HALF_CARD}"
			when 3
				13.times do |i|
					puts "#{cards_to_print[0][:card].get_row_string(i + 1)}" +
						"#{SPACE_BETWEEN_CARDS}#{cards_to_print[1][:card].get_row_string(i + 1)}" +
						"#{SPACE_BETWEEN_CARDS}#{cards_to_print[2][:card].get_row_string(i + 1)}"
				end
				puts "#{HALF_CARD}#{cards_to_print[0][:index]}#{HALF_CARD}" +
					"#{SPACE_BETWEEN_CARDS}#{HALF_CARD}#{cards_to_print[1][:index]}#{HALF_CARD}" +
					"#{SPACE_BETWEEN_CARDS}#{HALF_CARD}#{cards_to_print[2][:index]}#{HALF_CARD}"
			else
				raise Exception, "This should not happen"
			end
		end

		puts SEPARATOR

		hints = "Hints:"
		hash_of_data['hints'].each do |h|
			hints += " #{h}"
		end

		puts "Cards Remaining: #{hash_of_data['cards_left'] + hash_of_data['cards'].size}, #{hints}"

		puts SEPARATOR

		self.print_scores hash_of_data['players']

		puts SEPARATOR

	end

	def prompt
		if @debug then DEBUG_PROMPT else PROMPT end
	end

  #if all players are stuck, then we slowly show more hints until a full set is displayed.
	def stuck
		JSON.parse(get "/stuck?name=#{@player_name}")
	end

	def start
		puts prompt

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

  #this printing thread is separate from the thread which reads user input. the thread reading user input is blocking.
	def start_game_print_thread
		@game_print_thread = Thread.new do
			cached_data = nil

			loop do
				data = self.get_data

				if data['started'] && data != cached_data
					clear
					self.print_game_data data

					if data['game_over']
						@continue_playing = false

						puts "Game Over! Deck is empty or there are no more sets!"
						self.print_scores data['players']
					end

				elsif data != cached_data
					self.print_players
				end

				cached_data = data

				sleep SECONDS_BETWEEN_POLLS

			end
		end
	end

  #runs on its own thread, and receives user input.
  #Example: when user enters a set, it goes to the server (blocking) and gets whether or not it is a set
  #The game printing loop is constantly getting information from the server to see if there are any updates
	def input_loop
		can_start = true
		@continue_playing = true

		while @continue_playing
			begin
				input = gets.chomp
			rescue
				input = "help"
			end

			if @continue_playing then
				case input
				when /\Aplayers\Z/i
					self.print_players

				when /\Aset [a-z] [a-z] [a-z]\Z/i

					split = input.split

					if self.is_set? split[1], split[2], split[3]
						puts "You found a set! :D"
					else
						puts "Sorry! That wasn't a set. :("
					end

				when /\Astart\Z/i
					if can_start && self.start_game then
						puts "Game is starting!"
					else
						puts "Could not start game! Game may already be in progress."
					end

					can_start = false

				when /\Ahelp\Z/i # print list of commands on /help
					puts prompt

				when /\Astuck\Z/i # send stuck signal to server
					puts "Sent stuck signal to server..."
					puts "Stuck Players: #{self.stuck['stuck_count']}"


				when /\Areset\Z/i # reset game on /reset command
					if @debug then
						clear
						puts 'Resetting Game...'
						self.new_game

						if self.connect then
							puts "Reset Successfully. Playing as #{@player_name}. Type 'start' to start the game."
						else
							puts "Could not re-register name after game reset. Type 'quit' to quit"
						end
					else
						puts "ERROR '#{input}' IS INVALID -> #{prompt}"
					end
				when /\Aquit\Z/i #quit game on /quit command
					@continue_playing = false

				else # Display Error Message On Invalid Command
					puts "ERROR '#{input}' IS INVALID -> #{prompt}"
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
