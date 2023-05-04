
class Event_NPC < Event_Base
    attr_accessor :stats, :groupName, :priority, :moveState, :facing
    attr_reader :moveType, :targetObject, :nature
    include Animate#number,name,x,y,activateType,imgName,bbHeight,bbWidth,facing,battleCoreName,commands
    def initialize(mapNumber,eventName,x,y,activateType,imgName,bbHeight,bbWidth,battleCoreName="ghost",facing="downStop",commands=[],behavior=nil)
        super(mapNumber,eventName,x,y,imgName,false) #,activateType,0,activateEvent,4,4,bbHeight,bbWidth
        @behavior = behavior || {:nature=>"evil",:groupName=>"#{@nature}_#{@name}_#{battleCoreName}",:priority=>['self'],:moveType=>"none", :detectRange=>6}
        @nature = @behavior['nature'] || "evil"
        @groupName = @behavior['groupName'] || "#{@nature}_#{@name}_#{battleCoreName}"
        @detectRange = @behavior['detectRange'] || 6
        @priority = @behavior['priority'] || ['self']
        @moveType = @behavior['moveType'] || "none" # "follow" or "random" or "none"
        stats =  @behavior['stats'] || nil
        @stats = stats ? Stats.new(stats['hp'],stats['atk'],stats['sAtk'],stats['def'],stats['sDef'],stats['speed']) : Stats.new(15,12,10,10,10,1)
        @targetObject = $scene_manager.scenes["player"] # need a target to "follow"
        @moveState = "stop" # "stop" or "move"
        @moveCenter = Move_Controller.new(@object,@facing,nil,@name,@moveState)
        @moveBuilder = Star_Movement.new(@moveCenter,Vector.new(@x,@y),@name,1)
        @actionController = Action_Core.new(@moveBuilder,@name,@object,@stats,@moveType,@groupName,@moveCenter,@facing, @priority,@nature ,@detectRange)
        
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