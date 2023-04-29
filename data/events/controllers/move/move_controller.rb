class Move_Controller
    include Animate

    def initialize(object,facing,sprite,eventName,npcActionState=nil)
        @object = object
        @facing = facing
        # @sprite = sprite
        @speed = 0.75
        @animationTime = 7
        @state = "stop"
        @input = $scene_manager.input
        @eventName = eventName
        @npcActionState = npcActionState
        # @nonPlayerFunc = nonPlayerFunc
    end
    def setMoveState()
        case @state
        when "moving"
            # puts("_| #{@eventName} |_ state: #{@state}\n facing: #{@facing}\n speed: #{@speed}\n animationTime: #{@animationTime} \n objectX: #{@object.x} \n objectY: #{@object.y}")
            # @sprite.draw()
            draw_character(@object, @facing ,@animationTime)
        when "stop"
            # @sprite.draw()
            draw_character(@object,"#{@facing}Stop",1)
        end
    end
    def isColliding()
        collideResult = []
        thisEventNum = $scene_manager.currentMap.get_event_num($scene_manager.currentMap.events.each {|e| if e.name == @eventName then return e end})
        $scene_manager.currentMap.events.each {|e|
            if e.name != @eventName
                evNum = $scene_manager.currentMap.get_event_num(e)
                $scene_manager.currentMap.check_collision(evNum,thisEventNum)
                
            end
        }
        return collideResult.include?(true)
    end
    def move_input()
        isColliding = isColliding()
        if Gosu.button_down?(InputTrigger::RUN) 
            @speed = 1.25
            @animationTime = 5
        elsif Gosu.button_down?(InputTrigger::SNEAK)
            @speed = 0.25
            @animationTime = 10
        else
            @speed = 0.75
            @animationTime = 7
        end
        if isColliding == false
            if @input.keyDown(InputTrigger::UP)
                @facing = "up"
                @state = "moving"
                move()
            elsif @input.keyDown(InputTrigger::DOWN)
                @facing = "down"
                @state = "moving"
                move()
            elsif @input.keyDown(InputTrigger::LEFT)
                @facing = "left"
                @state = "moving"
                move()
            elsif @input.keyDown(InputTrigger::RIGHT)
                @facing = "right"
                @state = "moving"
                move()
            end
        else
            move(true)
            if @input.keyDown(InputTrigger::UP)
                @facing = "up"
                @state = "stop"
            elsif @input.keyDown(InputTrigger::DOWN)
                @facing = "down"
                @state = "stop"
            elsif @input.keyDown(InputTrigger::LEFT)
                @facing = "left"
                @state = "stop"
            elsif @input.keyDown(InputTrigger::RIGHT)
                @facing = "right"
                @state = "stop"
            end
        end
        if @input.keyDown(InputTrigger::ESCAPE)
            @input.addToStack("menu")
            $scene_manager.switch_scene("menu")
        elsif @input.keyReleased(InputTrigger::UP)
            @state = "stop"
        elsif @input.keyReleased(InputTrigger::DOWN)
            @state = "stop"
        elsif @input.keyReleased(InputTrigger::LEFT)
            @state = "stop"
        elsif @input.keyReleased(InputTrigger::RIGHT)
            @state = "stop"
        end
    end
    def npc_input(actionState="stop")
        case actionState
        when "stop"
            @state = "stop"

        when "move"
            @state = "moving"
        end
    end
    def move(stop = false)
        vector = Vector.new(0, 0)
        vector.x = 0
        vector.y = 0
        if stop == false
            case @facing
            when "down"
                vector.y = @speed
            when "up"
                vector.y = -@speed
            when "right"
                vector.x = @speed
            when "left"
                vector.x = -@speed
            end
        else
            vector.x = 0
            vector.y = 0
        end
        @object.x += vector.x
        @object.y += vector.y
    end
    def update
        if @npcActionState != nil
            npc_input(@npcActionState)
        else
            move_input()
        end
    end
    def draw
        setMoveState()
    end
end