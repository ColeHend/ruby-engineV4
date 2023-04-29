class Map_Loader
    attr_accessor :maps
    def initialize(numOfMaps)
        @maps = []
        if numOfMaps > 0
            for i in 1..numOfMaps
                @maps.push(load_mapNumber(i))
            end
        end
    end
    def load_mapNumber(number)
        if number > 0
            mapInfo = JSON.parse(File.read(File.expand_path("./data/maps/mapData/map_#{number}.json")))
            mapTiles = JSON.parse(File.read(File.expand_path("./data/maps/mapData/map_#{number}_tiles.json")))
            theMap = Map_Template.new(mapInfo['tilesetName'],mapTiles,mapInfo["layers"])
            if mapInfo["events"].length > 0
                for i in 0..mapInfo["events"].length - 1
                    theEvent = mapInfo["events"][i]
                    name = theEvent["name"] ? theEvent["name"] : "M#{number}-Event#{i}"
                    x = theEvent["x"] ? theEvent["x"] : 0
                    y = theEvent["y"] ? theEvent["y"] : 0
                    activateType = theEvent["activateType"] ? theEvent["activateType"] : "select"
                    imgName = theEvent["image"] ? theEvent["image"] : "ghost"
                    bbHeight = theEvent["bbHeight"] ? theEvent["bbHeight"] : 32
                    bbWidth = theEvent["bbWidth"] ? theEvent["bbWidth"] : 32
                    battleCoreName = theEvent["battleCoreName"] ? theEvent["battleCoreName"] : "ghost"
                    facing = theEvent["facing"] ? theEvent["facing"] : "downStop"
                    commands = theEvent["commands"] ? theEvent["commands"] : []
                    theMap.add_event(Event_NPC.new(number,name,x,y,activateType,imgName,bbHeight,bbWidth,battleCoreName,facing,commands))
                end
            end
            return theMap
        end
        return map
    end
end