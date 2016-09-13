require 'rest-client'

class Client

	attr_accessor :ip_address, :port

	def initialize(ip_address, port, name)
		@ip_address = ip_address
		@port = port
		@player_name = name
	end

	def connect
			get '/auth?name=' + @player_name
	end

	def get_data
			get '/deck'
	end

	def new_game
			get '/new'
	end

	def start_game
			get '/start'
	end

	def is_set?(cardIndex1, cardIndex2, cardIndex3)
		get('/check-set?name=' + @player_name +
								'&card1=' + cardIndex1 +
								'&card2=' + cardIndex2 +
								'&card3=' + cardIndex3)
	end

	def stuck
		puts "TODO: Call To Server"
	end

	private def get(url_after_slash)
			RestClient.get full_name + url_after_slash
	end

	private def full_name
		"http://#{@ip_address}:#{@port}"
	end
end
