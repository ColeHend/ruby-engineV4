require_relative "./map_utilities.rb"
class Map_Base
  include Map_Utilities
    attr_accessor :w, :h, :events, :theMap, :mapTiles,:playersDraw, :blockedTiles, :runEffects
    def initialize(tileset,file,layers=5) 
        @mapTiles = tileset
        @events = []
        @layers = layers
        @runEffects = []
        @mapfile = file
        @mapArrayY = @mapfile['draw']
        @w = @mapArrayY.length
        @h = @mapArrayY[0].length
        @theMap = Map.new(32, 32, @w, @h, $scene_manager.screenWidth, $scene_manager.screenHeight, false, true)
        @camera_x = @camera_y = 0
        @blockedTiles = @mapTiles.impassableTiles
        @frameNum = 0
        mapRecordArr = draw_tile_loop(@w,@h,@mapArrayY,@mapTiles,@mapfile, @layers)
        @theMapRecord = mapRecordArr[0]
        @theMapRecordTop = mapRecordArr[1]
    end

    def get_event_num(event)
        return @events.index(event)
    end

    def check_collision(event1num,event2num)
      if event1num != nil && event2num != nil
        event1 = @events[event1num]
        event2 = @events[event2num]
        if event1.passible == false && event2.passible == false
          if event1.object.x + event1.object.w > event2.object.x && event1.object.x < event2.object.x + event2.object.w && event1.object.y + event1.object.h > event2.object.y && event1.object.y < event2.object.y + event2.object.h
              return true
          else
              return false
          end
        else
          return false
        end
      end
    end

    def currentBlockedTiles()
        @blockedTiles = @mapTiles.impassableTiles
        @events.each{|e|
            if e.passible == false
                @blockedTiles.push(e)
            end
        }
        return @blockedTiles
    end

    

    def update
      # -------- player -------
      $scene_manager.scenes["player"].update()
      @camera_x = [[($scene_manager.scenes["player"].x) - $scene_manager.screenWidth / 2, 0].max, ((@w * 32) + 32) - $scene_manager.screenWidth].min
      @camera_y = [[($scene_manager.scenes["player"].y) - $scene_manager.screenHeight / 2, 0].max, ((@h * 32) + 32) - $scene_manager.screenHeight].min
      # -------- events -------
      if @events.length > 0
        @events.each_with_index{|e,i| 
          e.update()
          # if e.stats.currentHP <= 0
          #   @events.delete_at(i)
          # end
        }
      end
      # -------- effects -------
      if @runEffects.length > 0
        @runEffects.each {|effect|
            effect.draw(nil,1,1,0xff,0xffffff,nil)
        }
      end
      #-------------------------
      currentBlockedTiles()
    end

    def draw()
        @frameNum += 1
        @events.map do |e| e.name == "player" ? $scene_manager.scenes["player"] : e end
        Gosu.translate(-@camera_x, -@camera_y) do
            @theMapRecord.draw(0,0,0)
            #@playersDraw.call()
            puts(@events.length)
            if @events.length > 0
                @events.each {|e|
                  if $scene_manager.scenes["player"].y != nil && e.y != nil
                    if $scene_manager.scenes["player"].y > e.y
                      e.draw()
                      $scene_manager.scenes["player"].draw
                    elsif $scene_manager.scenes["player"].y <= e.y
                      $scene_manager.scenes["player"].draw
                      e.draw()
                    end
                  end
                }
            else
                $scene_manager.scenes["player"].draw
            end
            @theMapRecordTop.draw(0,0,0)
            if @runEffects.length > 0
              @runEffects.each_with_index {|effect,index|
                  if effect.dead
                      @runEffects.delete_at(index)
                  else
                      effect.update
                  end
              }
          end
        end
    end

    def move_camera(x,y)
        @map.move_camera(x,y)
    end

    def set_camera(x,y)
        @map.set_camera(x,y)
    end
end