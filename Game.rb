require_relative './Deck'
class Game
  def initialize
    @deck = Deck.new
    @active_cards = []
    12.times do
      @active_cards << @deck.next_card
    end
  end

  #Interfaces with the card class to print
  def print
    chars = ('A'..'Z').to_a
    iterator = 0
    @active_cards.each do |card|
      puts card
      puts(chars[iterator])
      iterator += 1
    end
  end

  def deal(*indexes)
    indexes.each do |index|
      @active_cards[index] = @deck.next_card
    end
  end

  def playable?
    @deck.contains_set?
  end

  def is_set?(index_1, index_2, index_3)
    cards = get_cards(index_1, index_2, index_3)
    Card.is_set?(cards[0], cards[1], cards[2])
  end

  private

  def get_cards(index_1, index_2, index_3)
    ret = []
    ret << @active_cards[index_1]
    ret << @active_cards[index_2]
    ret << @active_cards[index_3]
  end
end
