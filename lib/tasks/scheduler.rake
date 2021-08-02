desc 'clear idle games'
task clear_idle: :environment do
  puts 'clearing old games...'
  Deck.pending_deletion.destroy_all
  Game.pending_deletion.destroy_all
  puts 'idle games cleared.'
end
