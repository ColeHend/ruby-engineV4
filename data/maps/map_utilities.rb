module Map_Utilities
    def draw_tile_loop(w,h,mapArrayY,mapTiles,mapfile, layers)
        theMapRecord = Gosu.record(w*32,h*32) do |x, y|
          if mapfile != nil
            mapArrayY.each_with_index {|mapArrayX, yIndex|
              mapArrayX.each_with_index {|tile, xIndex|
                for num in 0..(layers*0.5).ceil() do
                    if tile[num] != nil && tile[num] != "nil"
                      mapTiles.add_impass(tile[num],xIndex,xIndex)
                      mapTiles.draw_tile(tile[num],xIndex,yIndex)
                    end
                end
              }
            }
          end
        end
        theMapRecordTop = Gosu.record(@w*32,@h*32) do |x, y|
            if mapfile != nil
              mapArrayY.each_with_index {|mapArrayX, yIndex|
                mapArrayX.each_with_index {|tile, xIndex|
                  for num in (layers*0.5).ceil()..layers do
                      if tile[num] != nil && tile[num] != "nil" && tile[num] != -1
                        mapTiles.draw_tile(tile[num],xIndex,yIndex)
                      end
                  end
                }
              }
            end
          end
          return [theMapRecord,theMapRecordTop]
    end
end