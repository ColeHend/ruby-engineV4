class Move_Controller
    include Animate
    def initialize(object,facing,sprite,eventName,npcActionState=nil)
        @object = object
        @eventName = eventName
        getEvent = $scene_manager.currentMap.get_event_by_name(@eventName)
        @facing = getEvent ? getEvent.facing : facing
        @speed = 0.75
        @animationTime = 7
        @state = "stop"
        @input = $scene_manager.input
        @npcActionState = getEvent ? getEvent.moveState : "stop"
    end

    def setMoveState()
        state = @eventName != "player" ? @npcActionState : @state
        if @eventName != "player"
            getEvent = $scene_manager.currentMap.get_event_by_name(@eventName)
            state = getEvent ? getEvent.moveState.strip : state
            @facing = getEvent ? getEvent.facing : @facing
            @object = getEvent ? getEvent.object : @object
        end
        case state
        when "moving" 
            draw_character(@object, @facing ,@animationTime)
        when "move"
            draw_character(@object,@facing ,@animationTime)
        when "stop"
            draw_character(@object,"#{@facing}Stop",1)
        else 
            puts("Error: #{state} is not a valid move state")
            draw_character(@object,"downStop",1)
        end
    end

    def check_clear_path(direction) #can execute a move or not
        currEvent = @eventName == "player" ? $scene_manager.scenes["player"] : $scene_manager.currentMap.get_event_by_name(@eventName)
        
        if currEvent != nil
            $scene_manager.currentMap.currentBlockedTiles().each {|tile|
                determineCollision = $scene_manager.currentMap.detect_collision_side(currEvent.object, tile, false)
                if determineCollision && determineCollision.length > 0
                    if direction == "up" && determineCollision.include?("down") 
                        return false
                    elsif direction == "down" && determineCollision.include?("up") 
                        return false
                    elsif direction == "left" && determineCollision.include?("right") 
                        return false
                    elsif direction == "right" && determineCollision.include?("left") 
                        return false
                    end
                end
            }

            $scene_manager.currentMap.events.each {|event|
                determineCollision = $scene_manager.currentMap.detect_collision_side(currEvent, event)
                if determineCollision && determineCollision.length > 0 
                    if direction == "up" && determineCollision.include?("down") 
                        return false
                    elsif direction == "down" && determineCollision.include?("up") 
                        return false
                    elsif direction == "left" && determineCollision.include?("right") 
                        return false
                    elsif direction == "right" && determineCollision.include?("left") 
                        return false
                    end
                end
            }
        end

        return true
    end

    def move_input()
        if Gosu.button_down?(InputTrigger::RUN) 
            @speed = 2
            @animationTime = 5
        # elsif Gosu.button_down?(InputTrigger::SNEAK)
        #     @speed = 0.5
        #     @animationTime = 10
        else
            @speed = 1
            @animationTime = 7
        end
        
        upcheck = $scene_manager.scenes["player"].object.y > 0
        downcheck = $scene_manager.scenes["player"].object.y < (($scene_manager.currentMap.h-1)*32)
        leftcheck = $scene_manager.scenes["player"].object.x > 0
        rightcheck = $scene_manager.scenes["player"].object.x < (($scene_manager.currentMap.w-1)*32)

        if @input.keyDown(InputTrigger::UP)
            @facing = "up"
            @state = "moving"
            if check_clear_path("up") && upcheck
                move()
            end
        elsif @input.keyDown(InputTrigger::DOWN)
                @facing = "down"
                @state = "moving"
            if check_clear_path("down") && downcheck
                move()
            end
        elsif @input.keyDown(InputTrigger::LEFT)
                @facing = "left"
                @state = "moving"
            if check_clear_path("left") && leftcheck
                move()
            end
        elsif @input.keyDown(InputTrigger::RIGHT)
                @facing = "right"
                @state = "moving"
            if check_clear_path("right") && rightcheck
                move()
            end
        end
        
            
        if @input.keyDown(InputTrigger::ESCAPE)
            @input.addToStack("menu")
            $scene_manager.switch_scene("menu")
        elsif @input.keyReleased(InputTrigger::UP)
            @state = "stop"
            move(true)
        elsif @input.keyReleased(InputTrigger::DOWN)
            @state = "stop"
            move(true)
        elsif @input.keyReleased(InputTrigger::LEFT)
            @state = "stop"
            move(true)
        elsif @input.keyReleased(InputTrigger::RIGHT)
            @state = "stop"
            move(true)
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
        if @eventName != "player"
        else
            move_input()
        end
    end
    def draw
        setMoveState()
    end
end