class Map_Template < Map_Base
    def initialize(tilesetName,file,layers = 5)
        super(Tileset.new(tilesetName),file,layers)
    end
    def add_event(event)
        @events.push(event)
    end
    def add_effect(effect)
        @runEffects.push(effect)
    end
    def update
        super
    end
    def draw
        super
    end
end