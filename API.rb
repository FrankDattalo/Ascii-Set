require "sinatra"
require "sinatra/json"
require 'json'
require_relative './Player'
require_relative './Card'
require_relative './Server'

get '/deck' do
  json Server.instance.data
end

get '/auth' do
  name = params['name']

  accepted = false
  if !name.nil? && name != "" && !Server.instance.contains_player_name?(name) &&
      !Server.instance.started

    Server.instance.add_player Player.new name
    accepted = true
  end
  json accepted: accepted
end

get '/un-register' do
  name = params['name']
  if !name.nil? && name != "" && Server.instance.contains_player_name?(name)
    Server.instance.remove_player name
  end
  json response: 'ok'
end

get '/players' do
  json players: Server.instance.scores
end

get '/start' do
  hasStarted = Server.instance.started
  Server.instance.start if !hasStarted
  json game_playable: !hasStarted
end


get '/new' do
  Server.instance.re_init
  json Server.instance.data
end

get '/check-set' do
  name = params['name']
  card1 = params['card1'].capitalize
  card2 = params['card2'].capitalize
  card3 = params['card3'].capitalize
  player = Server.instance.get_player_by_name name
  active_cards = Server.instance.active_cards

  response = false

  if card1 != card2 && card2 != card3 && card1 != card3 &&
   Server.instance.started && active_cards.key?(card1) &&
   active_cards.key?(card2) &&
   active_cards.key?(card3) &&
   Card.is_set?(active_cards[card1],
   active_cards[card2], active_cards[card3])
   Server.instance.reset_hints

    player.score += 50 # a set

    Server.instance.remove_card_from_play active_cards[card1]
    Server.instance.remove_card_from_play active_cards[card2]
    Server.instance.remove_card_from_play active_cards[card3]

    Server.instance.deal_up_to_12
    Server.instance.re_index_cards
    Server.instance.update_game_over
    response = true

    Server.instance.reset_stuck_count

  elsif Server.instance.started
  player.score -= 5 # not a set
  end

  json is_set: response
end


get '/stuck' do
  name = params['name']
  Server.instance.increase_stuck_players name

  if Server.instance.all_players_stuck?
    if Server.instance.set_in_play? then
      Server.instance.deal_hints
    else
      Server.instance.deal_3_more_cards
      Server.instance.reset_stuck_count
    end
  end
  json stuck_count: Server.instance.stuck_player_count
end
