class Star_Movement
    attr_accessor :speed, :vectorToMove, :evtName, :facing, :state
    def initialize(moveCenter,vectorToMove,evtName,speed)
        @speed = speed
        @moveCenter = moveCenter
        @vectorToMove = vectorToMove
        @evtName = evtName
        @moveArray = []
        @facing = "down"
        @state = "stop"
        @moveLeft = ->(){
            @facing = "left"
            @state = "left"
        }
        @moveRight = ->(){
            @facing = "right"
            @state = "right"
        }
        @moveUp = ->(){
            @facing = "up"
            @state = "up"
        }
        @moveDown = ->(){
            @facing = "down"
            @state = "down"
        }
    end

    def buildPathToObject(objectToFollow)
        daMap = $scene_manager.currentMap
        endVect = Vector2.new(objectToFollow.x/32,objectToFollow.y/32)
        startLoc = [@vectorToMove.x.to_i,@vectorToMove.y.to_i]
        endLoc = [endVect.x.to_i,endVect.y.to_i]
        if endLoc[0] >= 0 && endLoc[1] >= 0
            if endLoc[0] <= daMap.w && endLoc[1] <= daMap.h
                puts("building a new path for #{@evtName}")
                thePath = Astar.new_path(startLoc,endLoc)
                thePath.pop()
                updatedPath = thePath[-1]
                currNode = startLoc
                thePath.each_with_index{|node,index|
                    xPos = node[0] - currNode[0]
                    yPos = node[1] - currNode[1]
                    numTimes = (32 / (0.25 * 4)).to_i
                   if yPos < 0 && xPos == 0 #up
                    numTimes.times{
                        @moveArray.push(@moveUp)
                    }
                   elsif yPos > 0 && xPos == 0 #down
                    numTimes.times{
                        @moveArray.push(@moveDown)
                    }
                   elsif yPos == 0 && xPos < 0 #left
                    numTimes.times{
                        @moveArray.push(@moveLeft)
                    }
                   elsif yPos == 0 && xPos > 0 #right
                    numTimes.times{
                        @moveArray.push(@moveRight)
                    }
                   end
                   currNode = node
                }
                return updatedPath
            end
        end
        return []
    end

    def update
        if @moveArray.length > 0
            @moveArray[0].call()
            @moveCenter.move()
            @moveArray.delete_at(0)
        else
            @moveCenter.move(true)
        end
    end
    def draw
    end
end