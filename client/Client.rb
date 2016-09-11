require 'rest-client'

class Client

	attr_accessor :ip_address, :port

	def initialize(ip_address, port)
		@ip_address = ip_address
		@port = port
	end

	def full_name
		"http://#{@ip_address}:#{@port}"
	end

	def register_name(name)
		RestClient.get self.full_name + '/auth?name=' + name
	end

	def game_data
		RestClient.get self.full_name + '/deck'
	end

	def new_game
		RestClient.get self.full_name + '/new'
	end

	def start_game
		RestClient.get self.full_name + '/start'
	end

end

c = Client.new('127.0.0.1', 3000)

puts c.register_name 'Frank'
puts c.start_game
puts c.game_data
