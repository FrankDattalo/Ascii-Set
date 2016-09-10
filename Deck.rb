require_relative "./Card"

class Deck

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

  def contains_set?
    range1 = (0..(@deck.length-1)).to_a
    range1.each do |x|
      range2 = ((x+1)..(@deck.length-1)).to_a
      range2.each do |y|
        range3 = ((y+1)..(@deck.length-1)).to_a
        range3.each do |z|
          card1 = @deck[x]
          card2 = @deck[y]
          card3 = @deck[z]
          if Card.is_set?(card1, card2, card3)
            return true
          end
        end
      end
    end

    #if we didn't escape after all of this, there was no set
    puts 'No set found in deck. Ending game.'
    false
  end

  def is_empty?
    !@deck.any?
  end

  def next_card
    @deck.pop
  end
end
