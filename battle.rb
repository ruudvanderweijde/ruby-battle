class Battle
    attr_accessor :fighters, :showProgress;
    def initialize(fighters, progress = true)
        @showProgress = progress;
        fighters.each{|x| add(Fighter.subclasses.sample().new(x));};
        run;
    end

    def add fighter
        @fighters ||= []
        @fighters << fighter
    end

    def run
        if fighters.length < 2 then p "Minimum of 2 fighters required." else
            fighterString = fighters.map{|p| "\x03#{p.color}#{p.name}\x0F (\x035#{p.class.to_s}\x0F)" }.join(", ")
            puts "The battle starts with #{fighters.length} fighters: #{fighterString}";
            while fighters.length > 1 do
                attacker, victim = fighters.sample(2)
                weapon = attacker.weapons.sample()
                damage = rand(weapon.min_damage..weapon.max_damage)
                victim.health -= damage
                variables = {
                    :attacker => "\x03"+attacker.color+attacker.name+"\x0F",
                    :attackerClass => "\x035"+attacker.class.to_s+"\x0F",
                    :victim => "\x03"+victim.color+victim.name+"\x0F",
                    :damage => "\x02"+damage.to_s+"\x0F damage",
                    :weapon => sprintf(weapon.context, { :weaponName => "\x02"+weapon.name+"\x0F"})
                }
                if victim.health <= 0 then
                    puts sprintf('%{attacker} does %{damage} to %{victim} %{weapon} and kills %{victim}.', variables);
                    fighters.delete(victim);
                elsif @showProgress then
                    puts sprintf('%{attacker} does %{damage} to %{victim} %{weapon}.', variables);
                end
            end
            flawless = if attacker.health == 100 then " Flawless!!" end
            puts sprintf('%{attacker} (%{attackerClass})  won!', variables) + flawless.to_s;
        end
    end
end

class Fighter
    attr_accessor :name, :health, :color, :weapons;
    @@colors = ["02","03","04","05","06","07","10","12"].shuffle()
    def initialize(name)
        @health = 100;
        @name = name;
        @color = @@colors.shift() || "01" 
    end

    def add weapon
        @weapons ||= []
        @weapons << weapon
    end
end

class BruceLee < Fighter
    def initialize(name)
        super(name)
        add(Weapon.new('Single Direct Attack', 0, 20));
        add(Weapon.new('Attack By Combination', 20, 40));
        add(Weapon.new('Progressive Indirect Attack', 40, 60));
        add(Weapon.new('(Hand) Immobilization Attack', 60, 80));
        add(Weapon.new('Attack by Drawing', 80, 100));
    end
end
class Goku < Fighter
    def initialize(name)
        super(name)
        add(Weapon.new('Tail Attack', 0, 20));
        add(Weapon.new('Dragon Fist', 20, 40));
        add(Weapon.new('Kamehameha', 40, 60));
        add(Weapon.new('Solar Flare', 60, 80));
        add(Weapon.new('Spirit Bomb', 80, 100));
    end
end
class Ryu < Fighter
    def initialize(name)
        super(name)
        add(Weapon.new('Punch', 0, 25));
        add(Weapon.new('Kick', 0, 25));
        add(Weapon.new('Hard Punch', 25, 50));
        add(Weapon.new('Hard Kick', 25, 50));
        add(Weapon.new('Hadoken', 50, 100));
        add(Weapon.new('Hurricane kick', 50, 100));
        add(Weapon.new('Shoryuken', 50, 100));
    end
end
class SEOMaster < Fighter
    def initialize(name)
        super(name)
        add(Weapon.new('Meta Tag', 0, 20));
        add(Weapon.new('Google Search', 20, 50));
        add(Weapon.new('Ejaculaat', 50, 100));
    end
end

class Executioner < Fighter
    def initialize(name)
        super(name)
        add(Weapon.new('Stoning', 0, 20));
        add(Weapon.new('Skinning', 20, 50));
        add(Weapon.new('Dismemberment', 50, 100));
    end
end

class CaptainPlanet < Fighter
    def initialize(name)
        super(name)
        add(Weapon.new('Earth', 0, 50));
        add(Weapon.new('Fire', 0, 50));
        add(Weapon.new('Wind', 0, 50));
        add(Weapon.new('Water', 0, 50));
        add(Weapon.new('Hearth', 0, 50));
        
        add(Weapon.new('Near invincibility', 50, 100));
        add(Weapon.new('Invisibility', 50, 100));
        add(Weapon.new('Telepathy', 50, 100));
        add(Weapon.new('Empathy', 50, 100));
        add(Weapon.new('Flight', 50, 100));
        add(Weapon.new('Superhuman strength', 50, 100));
    end
end

class Gaetan < Fighter
    def initialize(name)
        super(name)
        add(Weapon.new('MSN', 0, 1));
        add(Weapon.new('Smakken', 99, 99));
        add(Weapon.new('Angela', 0, 1));
    end
end

#http://pokemondb.net/pokedex/pikachu
class Pikachu < Fighter
    def initialize(name)
        super(name)
        add(Weapon.new('Feint', 0, 30));
        add(Weapon.new('Quick Attack', 0, 40));
        add(Weapon.new('Thundershock', 0, 40));
        add(Weapon.new('Discharce', 0, 80));
        add(Weapon.new('Slam', 0, (80*0.75)));
        add(Weapon.new('Thunderbolt', 0, 95));
        add(Weapon.new('Thunder', 0, (120*0.7)));        
    end
end

class Weapon
    attr_accessor :name, :min_damage, :max_damage, :context;
    def initialize(name, min_damage, max_damage, context = 'using %{weaponName}')
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
