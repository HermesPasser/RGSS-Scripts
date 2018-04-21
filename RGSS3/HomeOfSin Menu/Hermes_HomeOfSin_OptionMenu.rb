#==============================================================================
# Hermes Home of Sin Option Menu
#  by Hermes Passer (hermespasser@gmail.com)
#  gladiocitrico.blogspot.com
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Vocabulary
#------------------------------------------------------------------------------
$MUSIC         = 'Música'
$SOUND_EFFECT  = 'SFX'
$OTHER_OPTIONS = 'F1: Outras opções'

#------------------------------------------------------------------------------
# Flag to Mission option in Menu  will be enabled.
#------------------------------------------------------------------------------
HERMES_HOS_OPTION = 0

#------------------------------------------------------------------------------
# Volume global values
#------------------------------------------------------------------------------
$volume_sfx   = 100
$volume_music = 100

#------------------------------------------------------------------------------
# false = SFX will be the volume changed, true = music volume will be changed.
#------------------------------------------------------------------------------
$isSFX = false

class Scene_Option < Scene_Base
 def start
    super
    create_background
    create_windows
  end
  
  def create_windows
    @owindow = OptionWindow.new
    @owindow.set_handler(:cancel, method(:return_scene))
    @owindow.set_handler(:music,  method(:music_option))
    @owindow.set_handler(:sfx,    method(:sfx_option))
        
    @iwindow = Window_Info.new
  end

  def open_volume
    SceneManager.call(Scene_Volume)
  end
  
  def music_option
    $isSFX = false
    open_volume
  end
  
  def sfx_option
    $isSFX = true
    open_volume
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def dispose
    super
    @background_sprite.bitmap.dispose
  end
end

class OptionWindow < Window_Command
  def initialize()
    super(Graphics.width / 2 - 50, Graphics.height / 2 - 50)
  end
 
  def make_command_list
     add_command($MUSIC, :music)
     add_command($SOUND_EFFECT, :sfx)
  end
  
  def window_width
    100
  end
  
  def window_height
    75
  end
end

class Window_Info < Window_Base
  def initialize
    super(Graphics.width / 2 - 130 / 2, Graphics.height / 2 + 50, 130, 50)
    refresh
  end

  def refresh
    contents.clear
    draw_text(1, 1, 110, 30, $OTHER_OPTIONS)
  end
end

class Scene_Volume < Scene_Base
 def start
    super
    create_background
    create_windows
  end
  
  def create_windows
    @vwindow = Window_Volume.new
    @vwindow.set_handler(:cancel, method(:return_scene))
    @vwindow.set_handler(:v000, method(:v000))
    @vwindow.set_handler(:v020, method(:v020))
    @vwindow.set_handler(:v040, method(:v040))
    @vwindow.set_handler(:v060, method(:v060))
    @vwindow.set_handler(:v080, method(:v080))
    @vwindow.set_handler(:v100, method(:v100))
  end

  def change_volume volume
    $isSFX ? change_sfx(volume) : change_music(volume)
    return_scene
  end
  
  def change_sfx volume
    $volume_sfx = volume
    $data_system.sounds.each do |item|
      item.volume = volume
    end
  end
  
  def change_music volume
    $volume_music = volume
    
    $game_system.battle_bgm.volume    = volume
    $game_system.battle_end_me.volume = volume
    
    $game_map.map.bgm.volume = volume
    $game_map.map.bgs.volume = volume
    
    $data_system.gameover_me.volume = volume
    $data_system.title_bgm.volume   = volume
    $data_system.battle_bgm.volume  = volume
    
    $game_map.vehicles.each do |vehicle|
      vehicle.system_vehicle.bgm.volume = volume
    end
  end
  
  def v000; change_volume 0;   end
  def v020; change_volume 20;  end
  def v040; change_volume 40;  end
  def v060; change_volume 60;  end
  def v080; change_volume 80;  end
  def v100; change_volume 100; end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def dispose
    super
    @background_sprite.bitmap.dispose
  end
end

class Window_Volume < Window_Command
  def initialize()
    super(Graphics.width / 2 - 75 / 2, Graphics.height / 2 - 170 / 2)
  end
 
  def make_command_list
     add_command('000', :v000)
     add_command('020', :v020)
     add_command('040', :v040)
     add_command('060', :v060)
     add_command('080', :v080)
     add_command('100', :v100)
  end
  
  def window_width
    75
  end
  
  def window_height
    170
  end
end

#------------------------------------------------------------------------------
# Override classes
#------------------------------------------------------------------------------
class Game_Interpreter
  attr_accessor :params
  # * Play BGM
  def command_241
    @params[0].volume = $volume_music
    @params[0].play
  end
  # * Play BGS
  def command_245
    @params[0].volume = $volume_music
    @params[0].play
  end
  # * Play ME
  def command_249
    @params[0].volume = $volume_sfx
    @params[0].play
  end
  # * Play SE
  def command_250
    @params[0].volume = $volume_sfx
    @params[0].play
  end
end

class Game_Map
  attr_accessor :map
end
  
class Game_Map
  attr_accessor :vehicles
end
  