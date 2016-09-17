require_relative './Deck'
require_relative './Card'
require_relative './Player'
require 'singleton'


# The Server class encapsulates all of the game objects for a single instance
# of the game.  IE - when hosting a game, there exists one Server class that
# represents the game.
class Server
  include Singleton

  # Server constructor
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

  # This method will update the game_over instance variable
  # when called.  The variable will be assigned true iff
  # there are not cards to play or there is no set are cards to play
  def update_game_over
    @game_over = true unless (@deck.size + @active_cards.size) > 0 && (self.set_in_play?(add_hints: false) || deck.contains_set?)
  end

  # This method will remove the player with the name name from the game_over
  # it also reinstances the game if all players have quit
  def remove_player(name)
    @players.delete_if do |player|
      player.name == name
    end

    if @players.empty?
      self.re_init
    end
  end

  # This method resets the hint system to having no hints
  def reset_hints
    @hints = []
    @private_hints = []
  end

  # This method will remove the given card from play and re-index the cards
  # that still remain in play.  This method will not attempt to deal any cards.
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

  # This method will return the next index that should be used for a card given
  # all current indecies.  aka if cards 1 - 12 are in play next_index will
  # return 'M'
  def next_index
    ('A'..'Z').to_a[@active_cards.size]
  end

  # This method will increase the count of stuck players so long as the current
  # play is not already stuck.  This method is used for hint generation.
  def increase_stuck_players(player)
    unless @stuck_players.include? player
      @stuck_player_count += 1
      @stuck_players << player
    end
  end

  # This method will report whether all players are stuck, useful for hint
  # generation.
  def all_players_stuck?
    @players.size <= @stuck_player_count
  end

  # This method will reset the count of stuck players,
  # useful for hint generation.
  def reset_stuck_count
    @stuck_players = []
    @stuck_player_count = 0
  end

  # Reports wether the player name player exists in the current game.
  def contains_player_name?(player)
    @players.each do |p|
      return true if p.name == player
    end
    false
  end

  # Returns the player object corresponding to the name name.
  # A player object with the name name must exist within the current game.
  def get_player_by_name(name)
    @players.each do |p|
      return p if p.name == name
    end
  end

  # Adds a player to the game.
  def add_player(player)
    @players << player
  end

  # Reports whether the current game is in progress.
  def started
    @started
  end

  # Starts the current game and deals cards.
  def start
    @started = true
    self.deal_up_to_12
  end

  # Deals up to 12 cards so long as the deck is not empty.
  def deal_up_to_12
    while @active_cards.size < 12 && !@deck.is_empty?
      @active_cards[self.next_index] = @deck.next_card
    end
  end

  # Re-indexes the cards such that the indecies of each card are the most
  # alphabetically ordered letters.
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

  # Deals 3 cards so long as the deck is not empty.
  def deal_3_more_cards
    3.times do
      @active_cards[self.next_index] = @deck.next_card unless @deck.is_empty?
    end
  end

  # Attempts to deal hints so long as there are adequate hints to provide, and
  # hints have not already been provided.
  def deal_hints
    return if @hints.any?
    Thread.new do
      @private_hints.shuffle! if @private_hints.any?
      @hints << @private_hints[0] if @private_hints.any? && @private_hints.size > 0
      sleep 3
      @hints << @private_hints[1] if @private_hints.any? && @private_hints.size > 1
      sleep 3
      @hints << @private_hints[2] if @private_hints.any? && @private_hints.size > 2
    end
  end

  # Returns a hash of public game data.
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

  # Returns the deck object corresponding to this game.
  def deck
    @deck
  end

  # Returns the player array corresponding to this game.
  def players
    @players
  end

  # Returns a hash of active cards corresponding to this game.
  def active_cards
    @active_cards
  end

  # Re initializes the game.
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

#returns whether or not there is a set in play
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

  #keeps count of all the player that are stuck
  def stuck_player_count
    @stuck_player_count
  end

  #keeps track of the game score
  def scores
    sorted = @players.sort do |a, b|
      b.score <=> a.score
    end
    sorted
  end

end
