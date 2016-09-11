require_relative './Game'
game = Game.new
while game.playable?
  game.print
  entry = gets
  args = entry.split ' '
  indexes = []
  args.each do |card_entry|
    index = card_entry.ord - 'A'.ord
    indexes << index
  end
  if game.is_set?(indexes[0], indexes[1], indexes[2])
    puts 'You found a set!'
    game.deal(indexes[0], indexes[1], indexes[2])
  else
    puts 'You did not find a set!'
  end

end