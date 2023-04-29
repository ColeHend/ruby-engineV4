require 'minigl'
require 'JSON'
include MiniGL
Dir[File.join(__dir__,'data', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'data','events', '*.rb')].each { |file| require file }
Dir[File.join(__dir__,'data','events','controllers' , 'battle', '*.rb')].each { |file| require file }
Dir[File.join(__dir__,'data','events','controllers'  ,'action', '*.rb')].each { |file| require file }
Dir[File.join(__dir__,'data','events','controllers'  ,'move', '*.rb')].each { |file| require file }
Dir[File.join(__dir__,'data', 'maps','*.rb')].each { |file| require file }
Dir[File.join(__dir__,'data', 'input', '*.rb')].each { |file| require file }

SCREEN_WIDTH, SCREEN_HEIGHT = 800, 600
class MyGame < GameWindow
    def initialize
        super SCREEN_WIDTH, SCREEN_HEIGHT, false 
        $window = self
        $scene_manager = Scene_Manager.new(SCREEN_WIDTH,SCREEN_HEIGHT)
        $scene_manager.startUp()
        $scene_manager.setScene("titlescreen")
    end
    def update
        $time = Gosu::milliseconds()
        self.caption = "Game FPS = " +(Gosu.fps()).to_s
        KB.update
        $scene_manager.update
    end
    def draw
        $scene_manager.draw
    end
end
game = MyGame.new
game.show