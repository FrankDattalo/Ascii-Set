require_relative "./SetChecker"
require_relative "./Deck"

deck = Deck.new
while !deck.is_empty?
  c1 = deck.next_card
  c2 = deck.next_card
  c3 = deck.next_card

  puts c1
  puts c2
  puts c3

  puts "Is Set: #{SetChecker.is_set? c1, c2, c3}"
end
