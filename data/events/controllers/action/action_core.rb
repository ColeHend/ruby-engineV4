class Action_Core
    def initialize(moveBuilder,eventName,actionObject,stats,moveType,groupName, moveController,facing,priority='self',state="neutral",range=nil)
        getEvent = $scene_manager.currentMap.get_event_by_name(eventName)
        @actionObject = getEvent ? getEvent.object : actionObject
        @facing = facing
        @stats = stats
        @eventName = eventName
        @moveType = moveType # "none" or "random" or "follow"
        @detection# = MoveCollision.new(@actionObject)
        @range = range ? range : 6
        @moveBuilder = moveBuilder # @moveBuilder.buildPathToObject(targetObject) moves to target and returns an array of directions
        @priority = priority # "self" or "player" or (other && x,y coordinates of priority location)
        @state = state
        @moveController = moveController
        @groupName = groupName
        @@group_natures = Hash.new
        @@group_natures[@groupName] = Hash.new
        @natures = $scene_manager.npcNatures # ["friendly","neutral","evil","ally"]
        @move_dir_array = []
    end

    def actionNatureState()
        move_to_potential_target()
        
    end

    def move_to_potential_target()
        getEvent = $scene_manager.currentMap.get_event_by_name(@eventName)

        if @move_dir_array.length == 0
            move_event(false)
            potentialTargets = @priority.length == 1 ? get_target_priorities(@priority[0]) : get_target_priorities(@priority[0],@priority[1])
            if potentialTargets.length > 0
                @move_dir_array = @moveBuilder.buildPathToObject(potentialTargets[0])
            end
        else
            upcheck = getEvent.object.y > 1
            downcheck = getEvent.object.y < (($scene_manager.currentMap.h-1)*32)
            leftcheck = getEvent.object.x > 1
            rightcheck = getEvent.object.x < (($scene_manager.currentMap.w-1)*32)
            facingCheck = @moveController.check_clear_path(@move_dir_array[0])
            puts("facingCheck: #{facingCheck}")
            puts("upcheck: #{upcheck}")
            puts("downcheck: #{downcheck}")
            puts("leftcheck: #{leftcheck}")
            puts("rightcheck: #{rightcheck}")
            if getEvent.facing == 'up'
                move_event(upcheck == true && facingCheck == true)
            elsif getEvent.facing == 'down'
                move_event(downcheck == true && facingCheck == true)
            elsif getEvent.facing == 'left'
                move_event(leftcheck == true && facingCheck == true)
            elsif getEvent.facing == 'right'
                move_event(rightcheck == true && facingCheck == true)
            else
                move_event(false)
            end
            
        end
    end
    
    def move_event(moveEvent)
        getEvent = $scene_manager.currentMap.get_event_by_name(@eventName)
        if moveEvent
            getEvent.facing = @move_dir_array[0]
            getEvent.moveState = "move"
            @moveController.move() 
            @moveController.move(true)
            @move_dir_array.delete_at(0)
        else
            getEvent.moveState = "stop"
            @move_dir_array = []
            @moveController.move(true)
        end
    end

    def get_target_priorities(natureFocus="self",sortByXY=false)
        puts("natureFocus: #{natureFocus}")
        if natureFocus == "self" && sortByXY == false
            return sort_objects_by_distance(check_nature_targets(), @actionObject.x, @actionObject.y)
        elsif natureFocus == "player" && sortByXY == false
            playerX, playerY = $scene_manager.scenes["player"].object.x, $scene_manager.scenes["player"].object.y
            return sort_objects_by_distance(check_nature_targets(), playerX, playerY)
        elsif sortByXY.x.is_a?(Numeric) && sortByXY.y.is_a?(Numeric)
            return sort_objects_by_distance(check_nature_targets(), sortByXY.x, sortByXY.y)
        else
            return check_nature_targets()
        end
    end

    def sort_objects_by_distance(objects, target_x, target_y)
        def distance_to_target(object, target_x, target_y)
          dx = (object.x - target_x).abs
          dy = (object.y - target_y).abs
          Math.sqrt(dx**2 + dy**2)
        end
        if objects.length > 0
            objects.sort_by do |object|
              distance_to_target(object.object, target_x, target_y)
            end
        else
            []
        end
    end
    
    def check_nature_targets()
        potentialTargets = check_range(@range)
        confirmedTargets = []
        if potentialTargets.length > 0
            potentialTargets.each do |target|
                if target[1].groupName != @groupName && target[1].nature != @state
                    if @state == "evil"
                        if target[1].nature == "neutral"
                            confirmedTargets.push(target[1])
                        elsif target[1].nature == "peaceful"
                            confirmedTargets.push(target[1])

                        elsif target[1].nature == "ally"
                            confirmedTargets.push(target[1])
                            
                        elsif target[1].nature == "player"
                            confirmedTargets.push(target[1])
                        end
                    elsif @state == "neutral" 
                        if target[1].nature == "evil"
                            confirmedTargets.push(target[1])
                        end
                    elsif @state == "peaceful"
                        if target[1].nature == "evil"
                            confirmedTargets.push(target[1])
                        end
                    elsif @state == "ally"
                        if target[1].nature == "evil"
                            confirmedTargets.push(target[1])
                        end
                    end

                    if !@@group_natures[@groupName][target[1].groupName]
                        if @state != "evil"
                            @@group_natures[@groupName][target[1].groupName] = 'neutral'
                        else
                            @@group_natures[@groupName][target[1].groupName] = 'enemy'
                            confirmedTargets.push(target[1])
                        end
                    elsif @@group_natures[@groupName][target[1].groupName] == 'enemy'
                        confirmedTargets.push(target[1])
                    end
                end
            end
            
        
        end
        # For testing always add a target
        confirmedTargets.length == 0 ? potentialTargets.length > 0 ? confirmedTargets.push(potentialTargets[0][1]) : nil : nil
        # --------------------------------
        return confirmedTargets.uniq
    end

    def check_range(tileNum)# returns Array<["direction", theEvent, distance-away-number ]>
        tileW, tileH = 32, 32
        tileNum = tileNum ? tileNum : 6
        tileDistW, tileDistH = tileNum*tileW, tileNum*tileH
        theEvent = $scene_manager.currentMap.get_event_by_name(@eventName)
        theEvent ? theEvent = theEvent.object : theEvent = @actionObject
        x, y = theEvent.x, theEvent.y
        toReturn = []
        [*$scene_manager.currentMap.events,$scene_manager.scenes["player"]].uniq.each do |event|
            event2 = event.object
            if event != self
                if event2.x >= x - tileDistW && event2.x <= x + tileDistW && event2.y >= y - tileDistH && event2.y <= y + tileDistH
                    dist = Math.sqrt((event2.x - x)**2 + (event2.y - y)**2)
                   
                    if dist <= tileDistW
                        if event2.y < y
                            if event2.x < x
                                toReturn.push(["up-left", event, dist])
                            elsif event2.x > x
                                toReturn.push(["up-right", event, dist])
                            else
                                toReturn.push(["up", event, dist])
                            end
                        elsif event2.y > y
                            if event2.x < x
                                toReturn.push(["down-left", event, dist])
                            elsif event2.x > x
                                toReturn.push(["down-right", event, dist])
                            else
                                toReturn.push(["down", event, dist])
                            end
                        else
                            if event2.x < x
                                toReturn.push(["left", event, dist])
                            elsif event2.x > x
                                toReturn.push(["right", event, dist])
                            end
                        end
                    end
                end
            end
            
        end
        puts("check_range(#{@range}).toReturn.length: #{toReturn.length} | x: #{x} #{@actionObject.x}, y: #{y} #{@actionObject.y}|")
        return toReturn.uniq
    end

    def update
        puts("eventName: #{@eventName}, @move_dir_array.length: #{@move_dir_array.length}")
        actionNatureState()
    end

    def draw
    end
end