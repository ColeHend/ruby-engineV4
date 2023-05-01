
class Event_NPC < Event_Base
    attr_accessor :stats, :groupName, :priority, :moveState, :facing
    attr_reader :moveType, :targetObject, :nature
    include Animate#number,name,x,y,activateType,imgName,bbHeight,bbWidth,facing,battleCoreName,commands
    def initialize(mapNumber,eventName,x,y,activateType,imgName,bbHeight,bbWidth,battleCoreName="ghost",facing="downStop",commands=[])
        super(mapNumber,eventName,x,y,imgName,false) #,activateType,0,activateEvent,4,4,bbHeight,bbWidth
        @nature = "evil"
        @groupName = "#{@nature}_#{@name}_#{battleCoreName}"
        @detectRange = 6
        @stats = Stats.new(15,12,10,10,10,1)
        @moveType = "none" # "follow" or "random" or "none"
        @targetObject = $scene_manager.scenes["player"] # need a target to "follow"
        @moveState = "stop" # "stop" or "move"
        @moveCenter = Move_Controller.new(@object,@facing,nil,@name,@moveState)
        @moveBuilder = Star_Movement.new(@moveCenter,Vector.new(@x,@y),@name,1)
        @priority = 'self'
        @actionController = Action_Core.new(@moveBuilder,@name,@object,@stats,@moveType,@groupName,@moveCenter,@facing, @priority,@nature ,@detectRange)
        @behavior = {:nature=>"evil",:groupName=>"#{@nature}_#{@name}_#{battleCoreName}",:priority=>['self'],:moveType=>"none", :detectRange=>6}
        
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
        @moveBuilder.update()
        @moveCenter.update()
        @actionController.update()
    end

    def draw
        super
        # executes the move path for the npc
        @moveCenter.draw()
        @actionController.draw()
    end
end