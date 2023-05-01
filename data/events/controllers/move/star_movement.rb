require_relative './move_star.rb'
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
        endVect = Vector.new(objectToFollow.x/32,objectToFollow.y/32)
        startLoc = [@vectorToMove.x.to_i,@vectorToMove.y.to_i]
        endLoc = [endVect.x.to_i,endVect.y.to_i]
        if endLoc[0] >= 0 && endLoc[1] >= 0
            if endLoc[0] <= daMap.w && endLoc[1] <= daMap.h
                puts("building a new path for #{@evtName}")
                thePath = AStar.new_path(startLoc,endLoc)
                thePath.pop()
                updatedPath = thePath[-1]
                currNode = startLoc
                pathBuilt = []
                thePath.each_with_index{|node,index|
                    xPos = node[0] - currNode[0]
                    yPos = node[1] - currNode[1]
                    daSpeed = @speed < 1 ? 1 : @speed
                    numTimes = (32 / (daSpeed)).to_i
                   if yPos < 0 && xPos == 0 #up
                    numTimes.times{
                        @moveArray.push(@moveUp)
                        pathBuilt.push("up")
                    }
                   elsif yPos > 0 && xPos == 0 #down
                    numTimes.times{
                        @moveArray.push(@moveDown)
                        pathBuilt.push("down")
                    }
                   elsif yPos == 0 && xPos < 0 #left
                    numTimes.times{
                        @moveArray.push(@moveLeft)
                        pathBuilt.push("left")
                    }
                   elsif yPos == 0 && xPos > 0 #right
                    numTimes.times{
                        @moveArray.push(@moveRight)
                        pathBuilt.push("right")
                    }
                   end
                   currNode = node
                }
                # puts("path built #{pathBuilt}")
                # puts("thePath #{thePath}")
                # puts('-----------------------')
                return pathBuilt#updatedPath
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