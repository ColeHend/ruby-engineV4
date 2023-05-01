class Event_Player < Event_Base
    attr_accessor :stats
    attr_reader :nature, :groupName
    def initialize(map,x,y,img)
        super(map,'player',x,y,img,false)#map,evtName,x,y,img,passible=true
        @moveCenter = Move_Controller.new(@object,@facing,nil,'player')
        @stats = Stats.new(10,5,4,2,3,1)
        @nature = "player"
        @groupName = "player"
    end

    def update
        super
        @moveCenter.update
    end

    def draw
        super
        @moveCenter.draw
    end
end