require_relative "./custom_object.rb"
class Event_Base < CustObject
    attr_reader :name, :facing, :passible
    def initialize(map,evtName,x,y,img,passible=true)
        super(map, x, y, 32, 48, "sprites/#{img}")
        # @object = CustObject.new(map, x, y, 32, 48, "sprites/#{img}")
        @vector = Vector.new(0, 0)
        @name = evtName
        @passible = passible
        @facing = "down"
    end
    # def x
    #     return @object.x
    # end
    # def y
    #     return @object.y
    # end
    def facing
        return @facing
    end
    def object
        return @object
    end
    def vector
        return @vector
    end
    def passible
        return @passible
    end
    def update
    end
    def draw
        if x() != nil && y() != nil
            @object.draw
        end
    end
end