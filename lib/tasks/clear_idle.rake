namespace :games do
  desc 'clear idle games'
  task clear_idle: :environment do
    Deck.pending_deletion.destroy_all
    Game.pending_deletion.destroy_all
  end
end
