require_relative "./Card"

class Deck

  #initializes the the card from a deck
  def initialize
    @deck = []

    Card.number.each do |number|
      Card.color.each do |color|
        Card.texture.each do |texture|
          Card.shape.each do |shape|
            @deck << Card.new(number, color, shape, texture)
          end
        end
      end
    end
    @deck.shuffle!
  end

  #goes through all of the available cards on the screen and checks if there is a set
  def contains_set?
    range1 = (0..(@deck.length-1)).to_a
    range1.each do |x|
      range2 = ((x+1)..(@deck.length-1)).to_a
      range2.each do |y|
        range3 = ((y+1)..(@deck.length-1)).to_a
        range3.each do |z|
          if x != y && x != z && y != z # ensure that the cards that we
            card1 = @deck[x]            # are looking at are not all the same
            card2 = @deck[y]
            card3 = @deck[z]
            if Card.is_set?(card1, card2, card3)
              return true
            end
          end
        end
      end
    end

    #if we didn't escape after all of this, there was no set
    false
  end

  #finds the size of the deck (#number of cards remaining)
  def size
    @deck.size
  end

  #figures out if the deck is empty
  def is_empty?
    !@deck.any?
  end

  #pops off the next card
  def next_card
    @deck.pop
  end
end
