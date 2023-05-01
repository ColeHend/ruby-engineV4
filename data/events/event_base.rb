require_relative "./custom_object.rb"
class Event_Base < CustObject
    attr_reader :name, :facing, :passible
    def initialize(map,evtName,x,y,img,passible=true)
        super(map, x, y, 32, 48, "sprites/#{img}")
        # @object = CustObject.new(map, x, y, 32, 48, "sprites/#{img}")
        @vector = Vector.new(0, 0)
        @name = evtName
        @passable = passible
        @facing = "down"
    end
    # def x
    #     return @object.x
    # end
    # def y
    #     return @object.y
    # end
    def object
        @object
    end
    def vector
        @vector
    end
    def vector(x,y)
        @vector.x = x
        @vector.y = y
    end
    def passible
        @passible
    end
    def update
    end
    def draw
        if @x != nil && @y != nil
            @object.draw
        end
    end
end