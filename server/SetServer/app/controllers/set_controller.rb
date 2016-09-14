require_relative '../models/Deck'
require_relative '../models/Card'
require_relative '../models/Player'

class SetController < ApplicationController

  # GET
  # returns the json data of the game
  # schema {players:[PLAYER ARRAY], cards:[CARD ARRAY], winning: WINNING_PLAYER}
  def deck
    render json: Game.instance.data
  end

  # GET
  # returns either the json data that represents the Game
  # or Rejected if the player cannot connect to the game
  # schema {accepted: TRUE OR FALSE, data: GAME DATA OR NIL }
  def auth
    name = params[:name]
    if !name.nil? && name != "" && !Game.instance.contains_player_name?(name) &&
      !Game.instance.started

      Game.instance.add_player Player.new name
      render json: { accepted: true }
    else
      render json: {accepted: false }
    end
  end

	def un_register
		name = params[:name]
		if !name.nil? && name != "" && Game.instance.contains_player_name?(name)
			Game.instance.remove_player name
		end
		render json: {} # nothing do here here?
	end

	def players
		render json: { players: Game.instance.scores }
	end

  # GET
  # response schema { gamePlayable: TRUE OR FALSE }
  # if gamePlayable is true, then the requester has started the game,
  # no check is made to see if the requester is a valid player.
  def start
    hasStarted = Game.instance.started
    Game.instance.start if !hasStarted
    render json: { game_playable: !hasStarted }
  end

  # GET
  # restarts the game with a new instance
  def new
    Game.instance.re_init
    self.deck
  end

  # GET
  # given name params and cards params
  def check_set
    name = params[:name]
    card1 = params[:card1].capitalize
		card2 = params[:card2].capitalize
		card3 = params[:card3].capitalize

    player = Game.instance.get_player_by_name name
		active_cards = Game.instance.active_cards

		response = false

    if Game.instance.started && active_cards.key?(card1) &&
			active_cards.key?(card2) &&
			active_cards.key?(card3) &&
			Card.is_set?(active_cards[card1],
				active_cards[card2], active_cards[card3])

      player.score += 50 # a set

			Game.instance.remove_card_from_play active_cards[card1]
			Game.instance.remove_card_from_play active_cards[card2]
			Game.instance.remove_card_from_play active_cards[card3]

			Game.instance.deal_up_to_12

			Game.instance.re_index_cards
			response = true
    elsif Game.instance.started
      player.score -= 5 # not a set
    end

	  render json: { is_set: response }
  end

	def stuck
		Game.instance.increase_stuck_players

		if Game.instance.all_players_stuck?
			# TODO: check to see if there is a set, if so issue a hint,
			# else deal 3 cards
		end

		render json: {} # Dont really need to return anything significant here
	end

end

class Game
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
