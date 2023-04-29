class Scene_Manager
    attr_accessor :screenWidth, :screenHeight, :scenes, :currentMap, :windowskin, :input, :maps, :npcNatures
    def initialize(screenWidth=800,screenHeight=600)
        @numOfMaps = Dir[File.join(__dir__,'maps','mapData', '*.json')].count { |file| File.file?(file) }
        @numOfMaps = (@numOfMaps/2).floor()
        @screenWidth = screenWidth
        @screenHeight = screenHeight
        @scenes = Hash.new
        @input = Input.new
        @current_scene = nil
        @currentMap = nil
        @windowskin = "fancyWindowSkin"
        @animations = JSON.parse(File.read(File.expand_path('./data/animation.json')))
        @windowskins = Hash.new
        @startWindowSkins = ["fancyWindowSkin","earthboundWindowSkin","blackWindowSkin"]
        @npcNatures = ["friendly","neutral","hostile","ally"]
    end
    def startUp
        @startWindowSkins.each{|windowskin|
            @windowskins[windowskin] = GameObject.new(0,0,0,0,"windowskin/#{windowskin}",nil,6,4)
        }
        #Loading Scenes
        @scenes["map"] = Scene_Map.new(@numOfMaps)
        @scenes["titlescreen"] = TitleScreen.new()
        @currentMap = @scenes["map"].currentMap
        @scenes["player"] = Event_Player.new(@currentMap.theMap,0,0,"player")
        @maps = @scenes["map"].allMaps
    end
    def getEffects(animationName,x,y)
        @animations.each{|anim|
            if anim.animationName == animationName
               return [
                   Effect.new(x-(anim.xOff[0]*32), y-(anim.yOff[0]*32), anim.imgName, anim.row, anim.col, anim.interv, anim.frames,nil,anim.sound,anim.soundExt,nil),#up
                   Effect.new(x-(anim.xOff[1]*32), y-(anim.yOff[1]*32), anim.imgName, anim.row, anim.col, anim.interv, anim.frames,nil,anim.sound,anim.soundExt,:vert),#down
                   Effect.new(x-(anim.xOff[2]*32), y-(anim.yOff[2]*32), anim.imgName, anim.row, anim.col, anim.interv, anim.frames,nil,anim.sound,anim.soundExt,nil),#left
                   Effect.new(x-(anim.xOff[3]*32), y-(anim.yOff[3]*32), anim.imgName, anim.row, anim.col, anim.interv, anim.frames,nil,anim.sound,anim.soundExt,:horiz)#right
               ]
                
            end
        }
    end
    def setScene(sceneName)
        @currentScene = @scenes[sceneName]
    end
    def update
        @currentScene.update()
    end
    def draw
        @currentScene.draw()
    end
end