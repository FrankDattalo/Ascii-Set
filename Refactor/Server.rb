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
	end

	def remove_card_from_play(card)
		new_cards = {}
		i = 0
		@active_cards.each_value do |card_in_play|
			new_cards[i] = card_in_play unless card == card_in_play
		end

		@active_cards = new_cards
		self.re_index_cards
	end

	def next_index
		('A'..'Z').to_a[@active_cards.size]
	end

	def increase_stuck_players
		@stuck_player_count += 1
	end

	def all_players_stuck?
		@players.size == @stuck_player_count
	end

	def reset_stuck_count
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
    while @active_cards.size < 12
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
		3.time do
			@active_cards[self.next_index] = @deck.next_card if @deck.contains_cards?
		end
	end

  def data
    {
        cards: @active_cards,
        players: self.scores,
        started: @started,
				game_over: @game_over,
				hints: @hints
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
	end

	def scores
		sorted = @players.sort do |a, b|
			b.score <=> a.score
		end
		sorted
	end

end
