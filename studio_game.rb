require_relative 'player'

player1 = Player.new("moe", 100)
player2 = Player.new("larry", 200)
player3 = Player.new("curly", 300)


knuckleheads = Game.new('Knuckleheads')
knuckleheads.add_player(player1)
knuckleheads.add_player(player2)
knuckleheads.add_player(player3)
knuckleheads.play(10) do
  knuckleheads.total_points >= 2000
end
knuckleheads.print_stats


