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
    
    def detect_collision_side(event1, event2)
      player_half_w = event1.object.w / 2
      player_half_h = event1.object.h / 2
      enemy_half_w = event2.object.w / 2
      enemy_half_h = event2.object.h / 2
      player_center_x = event1.object.x + event1.object.w / 2
      player_center_y = event1.object.y + event1.object.h / 2
      enemy_center_x = event2.object.x + event2.object.w / 2
      enemy_center_y = event2.object.y + event2.object.h / 2
    
      diff_x = player_center_x - enemy_center_x
      diff_y = player_center_y - enemy_center_y
      min_x_dist = player_half_w + enemy_half_w
      min_y_dist = player_half_h + enemy_half_h
      
      if diff_x.abs < min_x_dist && diff_y.abs < min_y_dist
        d1 = 0
        collideDirections = []
        if diff_x.abs < min_x_dist && diff_y < d1
          collideDirections.push("up")
        end
        if diff_x.abs < min_x_dist && diff_y > d1
          collideDirections.push("down")
        end
        if diff_y.abs < min_y_dist && diff_x < d1
          collideDirections.push("left")
        end
        if diff_y.abs < min_y_dist && diff_x > d1
          collideDirections.push("right")
        end
        return collideDirections.length > 0 ? collideDirections : []
        
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
      @camera_x = [[($scene_manager.scenes["player"].object.x) - $scene_manager.screenWidth / 2, 0].max, ((@w * 32) + 32) - $scene_manager.screenWidth].min
      @camera_y = [[($scene_manager.scenes["player"].object.y) - $scene_manager.screenHeight / 2, 0].max, ((@h * 32) + 32) - $scene_manager.screenHeight].min
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
          if @events.length > 0
            @events.each do |e|
              if $scene_manager.scenes["player"].y != nil && e.y != nil
                    if $scene_manager.scenes["player"].y > e.y
                      e.draw()
                      $scene_manager.scenes["player"].draw
                    elsif $scene_manager.scenes["player"].y <= e.y
                      $scene_manager.scenes["player"].draw
                      e.draw()
                    end
                  
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
        end
      end
  end