require 'rest-client'
require 'json'
require_relative './Card'

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

	def print_game_data(hash_of_game_data)

		puts SEPARATOR

		hash_of_data['cards'].each do |index, card|
			#number, color, shape, texture
			c = Card.new(card['number'], card['color'].to_sym, card['shape'].to_sym, card['texture'].to_sym)
			c.print
			puts index
		end

		puts SEPARATOR

		CLIENT.print_scores

		puts SEPARATOR

	end

	def stuck
		get '/stuck'
	end

	def players
		get '/players'
	end

	def start_game_print_thread
		@game_print_thread = Thread.new do
			cached_data = nil
			while true
				data = self.get_data
				if data['started'] && data != cached_data

					if data['game_over']
						continue_playing = false
					else
						clear
						self.display_game_data data
					end

				elsif data != cached_data
					self.print_players
				end

				cached_data = data

				sleep SECONDS_BETWEEN_POLLS

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
