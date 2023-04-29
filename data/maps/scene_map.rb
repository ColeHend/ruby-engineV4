class Scene_Map
    attr_accessor :runEffects, :allMaps, :currentMap, :mWidth, :mHeight
    def initialize(numOfMaps)
        @allMaps = Map_Loader.new(numOfMaps).maps
        puts("@allMaps.length: #{@allMaps.length}, \n numofMaps: #{numOfMaps}")
        @currentMap = @allMaps[0]
        @mWidth = @currentMap.w || 0
        @mHeight = @currentMap.h  || 0
        
    end
    def update
        @currentMap.update()
        
    end
    def draw
        @currentMap.draw()
        
    end
end