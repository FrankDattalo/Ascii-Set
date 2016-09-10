require_relative '../models/Deck'

class SetController < ApplicationController

  # returns the json data of the game
  # schema {players:[PLAYER ARRAY], cards:[CARD ARRAY], winning: WINNING_PLAYER}
  def deck
    render json: Game.instance.data
  end

  # returns either the json data that represents the Game
  # or Rejected if the player cannot connect to the game
  # schema {accepted: TRUE OR FALSE, data: GAME DATA OR NIL }
  def auth
    name = params[:name]
    accepted = false
    if !name.nil? && name != "" && !Game.instance.contains_player_name?(name)
      accepted = true
    end

    if accepted
      render json: { accepted: true, data: Game.instance.data }
    else
      render json: {accepted: false, data: nil }
    end
  end

  # restarts the game with a new instance
  def new
    Game.instance.re_init
    self.deck
  end

end

class Game
  include Singleton

  def initialize
    @deck = Deck.new
    @players = []
    @active_cards = []
    @winning = nil
  end

  def contains_player_name?(player)
    return false # fix this
    @players.each do |p|
      return true if p.name == player
    end
    false
  end

  def add_player(player)
    case player
    when PLayer
      # add new player here
    else
      throw Exception, "Not A Player Instance"
    end
  end

  def data
    {
        players: @players,
        cards: @active_cards,
        winning: @winning
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
  end
end
