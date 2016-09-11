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
    accepted = false
    if !name.nil? && name != "" && !Game.instance.contains_player_name?(name) &&
      !Game.instance.started
      accepted = true
    end

    if accepted
      Game.instance.add_player Player.new(name, nil, nil, 0) # fix this?
      render json: { accepted: true, data: Game.instance.data }
    else
      render json: {accepted: false, data: nil }
    end
  end

  # GET
  # response schema { gamePlayable: TRUE OR FALSE }
  # if gamePlayable is true, then the requester has started the game,
  # no check is made to see if the requester is a valid player.
  def start
    hasStarted = Game.instance.started
    Game.instance.start if !hasStarted
    render json: { gamePlayable: !hasStarted }
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
    cards = params[:cards]

    case cards
    when Array # should probably do some error checking maybe ayy lmao
      if Game.instance.contains_player_name? name
        player = Game.instance.get_player_by_name name

        if cards.size == 3 && Card.is_set?(cards[0], cards[1], cards[3])
          player.sore += 50 # a set
        else
          player.score -= 5 # not a set
        end
      end

    end
  end


  self.deck
end

class Game
  include Singleton

  def initialize
    @deck = Deck.new
    @players = []
    @active_cards = []
    @winning = nil
    @started = false
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
    case player
    when PLayer
      # add new player here
      @players << player
    else
      throw Exception, "Not A Player Instance"
    end
  end

  def started
    @started
  end

  def start
    @started = true
  end

  def deal_up_to_12
    while @active_cards.size < 12
      @active_cards << @deck.next_card
    end
  end

  def data
    {
        players: @players,
        cards: @active_cards,
        winning: @winning,
        started: @started
    }
  end

  def deck
    @deck
  end

  def players
    @players
  end

  def winning
    @winning
  end

  def re_init
    @deck = Deck.new
    @players  = []
    @active_cards = []
    @winning = nil
    @started = false
  end
end
