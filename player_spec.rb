require_relative 'player'
require_relative 'treasure_trove'
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
    @player.to_s.should == "I'm Moe with health of 100, points of 0, and a score of 100"
    end
    
    
  it "computes a score as the sum of its health and length of name" do
    @player.found_treasure(Treasure.new(:hammer, 50))
    @player.found_treasure(Treasure.new(:hammer, 50))
    @player.score.should == 200
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
      @player = Player.new("larry", 210)
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
  
  context "in a collection of players" do
    before do
      @player1 = Player.new("moe", 100)
      @player2 = Player.new("larry", 200)
      @player3 = Player.new("curly", 300)

      @players = [@player1, @player2, @player3]
    end
  
    it "is sorted by decreasing score" do
      @players.sort.should == [@player3, @player2, @player1]
    end
  end
  
  it "computes points as the sum of all treasure points" do
    #@player.points.should == 0

    @player.found_treasure(Treasure.new(:hammer, 50))

    @player.points.should == 50

    @player.found_treasure(Treasure.new(:crowbar, 400))
  
    @player.points.should == 450
  
    @player.found_treasure(Treasure.new(:hammer, 50))

    @player.points.should == 500
  end
  
  it "yields each found treasure and its total points" do
    @player.found_treasure(Treasure.new(:skillet, 100))
    @player.found_treasure(Treasure.new(:skillet, 100))
    @player.found_treasure(Treasure.new(:hammer, 50))
    @player.found_treasure(Treasure.new(:bottle, 5))
    @player.found_treasure(Treasure.new(:bottle, 5))
    @player.found_treasure(Treasure.new(:bottle, 5))
    @player.found_treasure(Treasure.new(:bottle, 5))
    @player.found_treasure(Treasure.new(:bottle, 5))
  
    yielded = []
    @player.each_found_treasure do |treasure|
      yielded << treasure
    end
  
    yielded.should == [
      Treasure.new(:skillet, 200), 
      Treasure.new(:hammer, 50), 
      Treasure.new(:bottle, 25)
   ]
  end
  
  it "can be created from a CSV string" do
      player = Player.from_csv("larry,150")
      
      player.name.should == "Larry"
      player.health.should == 150
  end
end
