require_relative "./Deck"

d = Deck.new

while !d.is_empty?
	card = d.next_card
	card.print
	puts card
end
