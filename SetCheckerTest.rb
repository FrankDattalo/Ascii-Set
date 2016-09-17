require_relative "./Card"
require_relative "./Deck"

#while the deck isnt empty it keeps going
deck = Deck.new
while !deck.is_empty?
  c1 = deck.next_card
  c2 = deck.next_card
  c3 = deck.next_card

  puts c1
  puts c2
  puts c3

  puts "Is Set: #{Card.is_set? c1, c2, c3}"
end
