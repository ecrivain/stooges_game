require_relative 'game'

# Outside of the class, we refer to the external state of an 
# object as its attributes.

class Player
  attr_reader :health
  attr_accessor :name
  
  
  def initialize(name, health=100)
    @name = name.capitalize
    @health = health
    @found_treasures = Hash.new(0)
  end
  
  # override sort method
  def <=>(other)
    other.score <=> score
  end
  # When you assign a value to the name attribute, 
  # you're actually sending a message to the name= method
  # Create your own version of the "name=" method to override 
  # its function
  # def name=(new_name)
  #   @name = new_name.capitalize
  # end
  
  def to_s 
    "I'm #{@name} with health of #{@health}, points of #{points}, and a score of #{score}"
  end
  
  def found_treasure(treasure) 
    @found_treasures[treasure.name] += treasure.points
    puts "#{@name} found a #{treasure.name} worth #{treasure.points} points."
    puts "#{@name}'s treasures: #{@found_treasures}"
  end
  
  def points
    @found_treasures.values.reduce(0, :+)
  end
  
  
  # virtual attribute's are used to access the score from outside Player class
  # (aka virtual accessor method)
  def score
    @health + points
  end
  
  def strong?
    @health > 200
  end

  def w00t
    @health += 15
    puts "#{@name} got w00ted!" 
  end
  
  def blam
    @health -= 10
    puts "#{@name} got blammed" 
  end
end

if __FILE__ == $0
  player = Player.new("moe", 100)
  puts player.name
  puts player.health
  player.w00t
  puts player.health
  player.blam
  puts player.health
  puts player.strong?
  puts player.points
end


require_relative 'player'
require_relative 'game_turn'
require_relative 'treasure_trove'

class Game
  attr_reader :title
  
  def initialize(title)
    @title = title.capitalize
    @players = []
  end
  
  def add_player(player)
    @players << player
  end
  
  def print_name_and_health(player)
    formatted_name = player.name.ljust(20, '.')
    puts "#{formatted_name} #{player.score}"
  end
  
  def total_points
    @players.reduce(0) { |sum, player| sum + player.points }
  end
  
  def print_stats
    strong_players = @players.select { |player| player.strong? }
    wimpy_players = @players.reject { |player| player.strong? }
    #or
    # strong_players, wimpy_players = @players.partition { |player | player.strong? }

    puts "\n#{@title} Statistics:"
    
    puts "\n#{strong_players.size} strong players:"
    strong_players.each do |player|
      print_name_and_health(player)
    end
    
    puts "\n#{wimpy_players.size} wimpy players:"
    wimpy_players.each do |player|
      print_name_and_health(player)
    end
    
    puts "\n#{@title} High Scores:"
    @players.sort.each do |player|
      print_name_and_health(player)
    end  
    
    @players.each do |player|
      puts "\n#{player.name}'s point totals:"
      puts "#{player.points} grand total points"
    end  
  
  puts "Total treasure points found #{total_points}"
    
  end
  
  def play(rounds)
    puts "There are #{@players.size} players in #{title}"
    
    @players.each do |player|
        puts player
    end
    
    1.upto(rounds) do |round|
      puts "\nRound #{round}:"
      @players.each do |player|
        GameTurn.take_turn(player)
        puts player
        puts "\n"
      end
    end
    
    
    
    treasures = TreasureTrove::TREASURES
    
    puts "\nThere are #{treasures.size} treasures to be found"
    treasures.each do |treasure|
      puts "A #{treasure.name} is worth #{treasure.points} points"
    end  
  end
end