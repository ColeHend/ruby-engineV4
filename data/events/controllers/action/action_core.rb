class Action_Core
    def initialize(actionObject,stats,moveType,targetObject,range=2*32,state="neutral")
        @actionObject = actionObject
        @stats = stats
        @moveType = moveType # "none" or "random" or "follow"
        @targetObject = targetObject # need a target to "follow"
        @detection# = MoveCollision.new(@actionObject)
        
        @range = range
        
        @state = state
        
    end

    def state_test()
        @state = "stop"
    end

    def actionNatureState()
        $scene_manager.npcNatures.each do |nature|
            if nature == @state && nature == "evil"
                nature_evil()
            elsif nature == @state && nature == "neutral"
                nature_neutral()
            elsif nature == @state && nature == "peaceful"
                nature_peaceful()
            elsif nature == @state && nature == "ally"
                nature_ally()
            end
        end
        
    end
    def nature_evil()
        if @evtsInRange.length > 0
            
        end
    end
    def nature_neutral()
        if @evtsInRange.length > 0
            
        end
    end
    def nature_peaceful()
        if @evtsInRange.length > 0
            
        end
    end
    def nature_ally()
        if @evtsInRange.length > 0
        else 
        end
    end

    def check_range(tileNum)# returns Array<Array<["direction", theEvent, distance-away-number ]>
        tileW, tileH = 32, 32
        tileNum = tileNum ? tileNum : 2
        tileDistW, tileDistH = tileNum*tileW, tileNum*tileH
        x, y = @actionObject.x, @actionObject.y
        toReturn = []
        [*$scene_manager.currentMap.events,$scene_manager.scenes["player"]].uniq.each do |event|
            if event != self
                puts("eventInRange?: #{event.x >= x - tileDistW && event.x <= x + tileDistW && event.y >= y - tileDistH && event.y <= y + tileDistH}")
                if event.x >= x - tileDistW && event.x <= x + tileDistW && event.y >= y - tileDistH && event.y <= y + tileDistH
                    dist = Math.sqrt((event.x - x)**2 + (event.y - y)**2)
                    puts(dist,tileDistW, dist <= tileDistW )
                    if dist <= tileDistW
                        if event.y < y
                            if event.x < x
                                toReturn.push(["up-left", event, dist])
                            elsif event.x > x
                                toReturn.push(["up-right", event, dist])
                            else
                                toReturn.push(["up", event, dist])
                            end
                        elsif event.y > y
                            if event.x < x
                                toReturn.push(["down-left", event, dist])
                            elsif event.x > x
                                toReturn.push(["down-right", event, dist])
                            else
                                toReturn.push(["down", event, dist])
                            end
                        else
                            if event.x < x
                                toReturn.push(["left", event, dist])
                            elsif event.x > x
                                toReturn.push(["right", event, dist])
                            end
                        end
                    end
                end
            end
            
        end
        return toReturn
    end

    def update
        @evtsInRange = check_range(@range)
        puts("evtsInRange: #{@evtsInRange.length}")
        actionNatureState()
    end

    def draw
    end
end