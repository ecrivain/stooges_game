#game.rb 
require_relative 'game_turn'

class Game
  attr_reader :title
  
  def initialize(title)
    @title = title.capitalize
    @players = []
  end
  
  def add_player(player)
    @players << player
  end
  
  def play
    puts "There are #{@players.size} players in #{title}"
    
    @players.each do |player|
        puts player
    end
    
    @players.each do |player|
      GameTurn.take_turn(player)
      puts player
    end
  end
end


# game_turn.rb
require_relative 'player'
require_relative 'die'

module GameTurn
  def self.take_turn(player)
    @player = player
    die = Die.new
    case die.roll
    when 1..2
      player.blam
    when 3..4
      puts "#{player.name} was skipped."
    else
      player.w00t
    end
  end
end
 
 
#player.rb 
require_relative 'game'

# Outside of the class, we refer to the external state of an 
# object as its attributes.

class Player
  attr_reader :health
  attr_accessor :name
  
  def initialize(name, health=100)
    @name = name.capitalize
    @health = health
  end
  
  # When you assign a value to the name attribute, 
  # you're actually sending a message to the name= method
  # Create your own version of the "name=" method to override 
  # its function
  # def name=(new_name)
  #   @name = new_name.capitalize
  # end
  
  def to_s 
    "I'm #{@name} with a health of #{@health} and a score of #{score}"
  end
  
  # virtual attribute's are used to access the score from outside Player class
  # (aka virtual accessor method)
  def score
    @health + @name.length
  end
  
  def strong?
    @health > 100
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
  player = Player.new("moe", 150)
  puts player.name
  puts player.health
  player.w00t
  puts player.health
  player.blam
  puts player.health
  puts player.strong?
end



# die.rb
class Die
  attr_reader :number
  
  def initialize
    roll
  end
  
  def roll
    @number = rand(1..6)
  end
end

if  __FILE__ == $0
  die = Die.new
  puts die.roll
  puts die.roll
  puts die.roll
end
 
 
 
 
 

# game_spec.rb
require_relative 'player'
require_relative 'die'

describe Game do

  before do
    @game = Game.new("Knuckleheads")

    @initial_health = 100
    @player = Player.new("moe", @initial_health)
    
    @game.add_player(@player)
  end
  
  it "has a title" do
      @game.title.should == "Knuckleheads"
    end
  
  it "w00ts the player of a high number is rolled" do
    Die.any_instance.stub(:roll).and_return(5)
    
    @game.play
    
    @player.health.should == @initial_health + 15
  end
  
  it "skips the player if a medium number is rolled" do
    Die.any_instance.stub(:roll).and_return(3)

    @game.play
    
    @player.health.should == @initial_health
  end
  
  it "blams the player of a low number is rolled" do
    Die.any_instance.stub(:roll).and_return(1)
    
    @game.play
    
    @player.health.should == @initial_health - 10
  end
end


# player_spec.rb 
describe Player do
  
  before do
    $stdout = StringIO.new # supress blam and w00t puts
    
    @player = Player.new("moe", 100)
    @inital_score = 90
  end
  
  it "has a capitalized name" do
    @player.name.should == "Moe"
  end
     
   
  it "has an initial health" do
    @player.health.should == 100
  end
  
  it "has a string representation" do
    @player.to_s.should == "I'm Moe with a health of 100 and a score of 103"
    end
    
    
  it "computes a score as the sum of its health and length of name" do
    @player.score.should == 103
  end

  it "increases health by 15 when w00ted" do
    @player.w00t
    @player.health.should == 115
  end

  it "decreases health by 10 when blammed" do
    @player.blam
    @player.health.should == 90
  end
  
  context "with a health greater than 100" do
    before do
      @player = Player.new("larry", 150)
    end
    
    it "is strong" do
      @player.should be_strong
    end
  end
  
  context "with a health of 100 or less" do
    before do
      @player = Player.new("larry", 100)
    end
    
    it "is weak" do
      @player.should_not be_strong
    end
  end
  
end

# studio_game.rb 
require_relative 'player'

player1 = Player.new("moe", 100)
player2 = Player.new("larry", 200)
player3 = Player.new("curly", 300)


knuckleheads = Game.new('Knuckleheads')
knuckleheads.add_player(player1)
knuckleheads.add_player(player2)
knuckleheads.add_player(player3)
knuckleheads.play


