
class Event_NPC < Event_Base
    attr_accessor :stats, :object
    attr_reader :moveType, :targetObject
    include Animate#number,name,x,y,activateType,imgName,bbHeight,bbWidth,facing,battleCoreName,commands
    def initialize(mapNumber,eventName,x,y,activateType,imgName,bbHeight,bbWidth,battleCoreName="ghost",facing="downStop",commands=[])
        super(mapNumber,eventName,x,y,imgName,false) #,activateType,0,activateEvent,4,4,bbHeight,bbWidth
        @stats = Stats.new(15,12,10,10,10,1)
        @moveType = "none" # "follow" or "random" or "none"
        @targetObject = $scene_manager.scenes["player"] # need a target to "follow"
        @actionController = Action_Core.new(@object,@stats,@moveType,@targetObject,@detectRange,@nature)
        @moveCenter = Move_Controller.new(@object,@facing,nil,@name,"stop")
        @moveController = Star_Movement.new(@moveCenter,@vector,@name,@speed)
        @nature = "neutral"
        @detectRange = 3*32
     
    end
    def set_none()
        @moveType = "none"
    end
    def set_random()
        @moveType = "random"
    end

    def set_follow(object)
        @moveType = "follow"
        @targetObject = object
    end

    def setMoveAttack(distance,objectOfFocus,atkType)
        if @eventObject.w != nil || @eventObject.h != nil
            @facing
            focus(dist,objectOfFocus)
            @fightControl.eventAtkChoice(@self,@battle,@facing,dist,focus(dist,objectOfFocus),atkType) #  <- Starts its attack logic
          end
    end

    def update
        super
        @actionController.update()
        # makes sure the @moveType is set right in the @moveController
        #@moveController.update_move(self)
        @moveController.update()
        # creates a path for the npc to move to
    end

    def draw
        # executes the move path for the npc
        @moveController.draw()
        @actionController.draw()
    end
end