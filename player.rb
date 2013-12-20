require_relative 'game'
require_relative 'treasure_trove'
require_relative 'playable'

# Outside of the class, we refer to the external state of an 
# object as its attributes.

class Player
  include Playable
  
  attr_accessor :health
  attr_accessor :name
  
  
  def initialize(name, health=100)
    @name = name.capitalize
    @health = health
    @found_treasures = Hash.new(0)
  end
  
  def each_found_treasure
     @found_treasures.each do |name, points|
       yield Treasure.new(name, points)
     end
   end
   
  def self.from_csv(string)
    name, health = string.split(',')
    Player.new(name, Integer(health))
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
  
  def score
    @health + points
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