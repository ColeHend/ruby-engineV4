class CustObject < GameObject
    attr_accessor :map, :obj
    def initialize(map, x, y, w, h, img, sprite_cols = 4, sprite_rows = 4)
        super(x*32, y*32, w, h, img, Vector.new(2,2), sprite_cols, sprite_rows)
        @object = GameObject.new(x*32, y*32, w, h, img, Vector.new(2,2), sprite_cols, sprite_rows)
        @map = map
    end
    # def x
    #     return @obj.x
    # end
    # def y
    #     return @obj.y
    # end
    # def move(forces, obstacles, ramps)
    #     @obj.move(forces, obstacles, [])
    # end
    def draw
        @obj.draw(@map)
    end
    def update
        @obj.update()
    end
end