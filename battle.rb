class Battle
    attr_accessor :players, :showProgress;
    def initialize(players, progress = true)
        @showProgress = progress;
        players.each{|x| add(Player.subclasses.sample().new(x));};
        run;
    end

    def add player
        @players ||= []
        @players << player
    end

    def run
        if players.length < 2 then p "Minimum of 2 fighters required." else
            playerString = players.map{|p| "#{p.name} (#{p.class.to_s})" }.join(", ")
            print "The battle starts with #{players.length} players: #{playerString}";
            while players.length > 1 do
                ps=players.sample(2);
                weapon = ps[0].weapons.sample()
                h=rand(weapon.max_damage)+weapon.min_damage;
                ps[1].health -= h;
                if ps[1].health <= 0 then
                    print "#{ps[0].name} does \x02#{h}\xF damage to #{ps[1].name} and\x35 kills #{ps[1].name}\xF (#{ps[1].health}hp left) using attack \x02#{weapon.name}\xF.";
                    players.delete(ps[1]);
                else
                    if @showProgress then
                        print "#{ps[0].name} does \x02#{h}\xF damage to #{ps[1].name} using attack \x02#{weapon.name}\xF";
                    end
                end
            end
            players.each{|p| p "\x35#{p.name} won\xF#{if p.health == 100 then ' flawless!!' end}!"};
        end
    end
end

class Player
    attr_accessor :name, :health, :weapons;
    def initialize(name)
        @health = 100;
        @name = name;
    end

    def add weapon
        @weapons ||= []
        @weapons << weapon
    end


     def subclasses
       @subclasses ||= []
       @subclasses.inject( [] ) do |list, subclass|
         list.push(subclass, *subclass.subclasses)
       end
     end
end

class BruceLee < Player
    def initialize(name)
        super(name)
        add(Weapon.new('Single Direct Attack', 0, 20));
        add(Weapon.new('Attack By Combination', 20, 40));
        add(Weapon.new('Progressive Indirect Attack', 40, 60));
        add(Weapon.new('(Hand) Immobilization Attack', 60, 80));
        add(Weapon.new('Attack by Drawing', 80, 100));
    end
end
class Goku < Player
    def initialize(name)
        super(name)
        add(Weapon.new('Tail Attack', 0, 20));
        add(Weapon.new('Dragon Fist', 20, 40));
        add(Weapon.new('Kamehameha', 40, 60));
        add(Weapon.new('Solar Flare', 60, 80));
        add(Weapon.new('Spirit Bomb', 80, 100));
    end
end
class Ryu < Player
    def initialize(name)
        super(name)
        add(Weapon.new('Punch', 0, 25));
        add(Weapon.new('Kick', 0, 25));
        add(Weapon.new('Hard Punch', 25, 50));
        add(Weapon.new('Hard Kick', 25, 50));
        add(Weapon.new('Hadoken', 50, 100));
        add(Weapon.new('Shoryuken', 50, 100));
    end
end
class GJ < Player
    def initialize(name)
        super(name)
        add(Weapon.new('Ejaculaat', 20, 80));
    end
end

class Weapon
    attr_accessor :name, :min_damage, :max_damage, :context;
    def initialize(name, min_damage, max_damage, context = '%s')
        @name = name;
        @min_damage = min_damage;
        @max_damage = max_damage;
        @context = context;
    end
    
end

BEGIN {
   class Class
     def inherited other
       super if defined? super
     ensure
       ( @subclasses ||= [] ).push(other).uniq!
     end

     def subclasses
       @subclasses ||= []
       @subclasses.inject( [] ) do |list, subclass|
         list.push(subclass, *subclass.subclasses)
       end
     end
   end
}
