class Stats
    attr_reader :maxHP, :atk, :sAtk, :def, :sDef, :speed
    attr_accessor :currentHP
    def initialize(hp,atk,sAtk,defe,sDef,speed)
        @maxHP = hp
        @currentHP = @maxHP
        @atk = atk
        @sAtk = sAtk
        @def = defe
        @sDef = sDef
        @speed = speed
    end
    def setMaxHP(hp, heal=true)
        @maxHP = hp
        if heal == true
            @currentHP = @maxHP
        end
    end
    def setAtk(atk)
        @atk = atk
    end
    def setSAtk(sAtk)
        @sAtk = sAtk
    end
    def setDef(defe)
        @def = defe
    end
    def setSDef(sDef)
        @sDef = sDef
    end
    def setSpeed(speed)
        @speed = speed
    end
    def setStats(hp,atk,sAtk,defe,sDef,speed, heal=true)
        setMaxHP(hp, heal)
        setAtk(atk)
        setSAtk(sAtk)
        setDef(defe)
        setSDef(sDef)
        setSpeed(speed)
    end
end
