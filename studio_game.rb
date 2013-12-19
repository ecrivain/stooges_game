require_relative 'player'
require_relative 'clumsy_player'
require_relative 'berserk_player'


player1 = Player.new("moe", 100)
player2 = Player.new("larry", 200)
player3 = Player.new("curly", 300)

knuckleheads = Game.new('Knuckleheads')

knuckleheads.load_players(ARGV.shift || "players.csv")

clumsy = ClumsyPlayer.new("klutz", 105, 3)
knuckleheads.add_player(clumsy)

berserker = BerserkPlayer.new("berserk", 50)
knuckleheads.add_player(berserker)


loop do
  puts "\nHow many game rounds? ('quit' to exit)"
  answer = gets.chomp.downcase
  case answer
  when /^\d+$/
    knuckleheads.play(answer.to_i)
  when 'quit', 'exit'
    knuckleheads.print_stats
    break
  else
    puts "Please enter a number or 'quit'"
  end
end


knuckleheads.print_stats
knuckleheads.save_high_scores

