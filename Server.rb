require_relative './Deck'
require_relative './Card'
require_relative './Player'
require 'singleton'

class Server
  include Singleton

  def initialize
    @deck = Deck.new
    @players = []
    @active_cards = {}
    @started = false
		@stuck_player_count = 0
		@game_over = false
		@hints = []
		@private_hints = []
		@stuck_players = []
  end

	def update_game_over
		@game_over = true unless (@deck.size + @active_cards.size) > 0 && (self.set_in_play?(add_hints: false) || deck.contains_set?)
	end

	def remove_player(name)
		@players.delete_if do |player|
			player.name == name
		end

		if @players.empty?
			self.re_init
		end
	end

	def reset_hints
		@hints = []
		@private_hints = []
	end

	def remove_card_from_play(card)
		new_cards = {}
		i = 0
		@active_cards.each_value do |card_in_play|
			new_cards[i] = card_in_play unless card == card_in_play
			i += 1
		end

		@active_cards = new_cards
		self.re_index_cards
	end

	def next_index
		('A'..'Z').to_a[@active_cards.size]
	end

	def increase_stuck_players(player)
		unless @stuck_players.include? player
			@stuck_player_count += 1
			@stuck_players << player
		end
	end

	def all_players_stuck?
		@players.size <= @stuck_player_count
	end

	def reset_stuck_count
		@stuck_players = []
		@stuck_player_count = 0
	end

  def contains_player_name?(player)
    @players.each do |p|
      return true if p.name == player
    end
    false
  end

  def get_player_by_name(name)
    @players.each do |p|
      return p if p.name == name
    end
  end

  def add_player(player)
  	@players << player
  end

  def started # reports whether the current game is in progress
    @started
  end

  def start
    @started = true
		self.deal_up_to_12
  end

  def deal_up_to_12
    while @active_cards.size < 12 && !@deck.is_empty?
      @active_cards[self.next_index] = @deck.next_card
    end
  end

	def re_index_cards
		index = ('A'..'Z').to_a
		i = 0
		re_indexed_cards = {}

		@active_cards.each_value do | card |
			re_indexed_cards[index[i]]  = card
			i += 1
		end

		@active_cards = re_indexed_cards
	end

	def deal_3_more_cards
		3.times do
			@active_cards[self.next_index] = @deck.next_card unless @deck.is_empty?
		end
	end

	def deal_hints
		return if @hints.any?
		Thread.new do
			@hints << @private_hints[0]
			sleep 3
			@hints << @private_hints[1]
			sleep 3
			@hints << @private_hints[2]
		end
	end

  def data
    {
        cards: @active_cards,
        players: self.scores,
        started: @started,
				game_over: @game_over,
				hints: @hints,
				cards_left: @deck.size
    }
  end

  def deck
    @deck
  end

  def players
    @players
  end

	def active_cards
		@active_cards
	end

  def re_init
    @deck = Deck.new
    @players  = []
    @active_cards = {}
    @started = false
		@stuck_player_count = 0
		@game_over = false
		@hints = []
		@private_hints = []
		@stuck_players = []
  end

	def set_in_play?(hash = {add_hints: true})
		if @private_hints.any? then return true end
		@active_cards.each do |key1, value1|
			@active_cards.each do |key2, value2|
				@active_cards.each do |key3, value3|
					if key1 != key2 && key2 != key3 && key1 != key3 then
						if Card.is_set? value1, value2, value3 then
							if hash[:add_hints] then
								@private_hints = [key1, key2, key3]
							end
							return true
						end
					end
				end
			end
		end
		false
	end

  def stuck_player_count
    @stuck_player_count
  end

	def scores
		sorted = @players.sort do |a, b|
			b.score <=> a.score
		end
		sorted
	end

end
