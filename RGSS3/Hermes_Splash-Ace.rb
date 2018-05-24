#==============================================================================
# Hermes TitleSplash Ace 0.2
#  by Hermes Passer (hermespasser@gmail.com)
#  gladiocitrico.blogspot.com
#------------------------------------------------------------------------------
#  functionalities:
#	-  Show a splash screen before the title screen and you can skip pressing enter (C).
#  	-  Play the title music in the splash;
#  	-  Disable music in title.
#==============================================================================

#==============================================================================
# Add the images here separated by ','. All images must be in pictures folder.
# Not use space (' ') after the ',' to separate the images.
# example: "imageone, image two, the third one"
#==============================================================================
SPLASH_IMG_LIST = "Splash screen 1,Splash screen 2"

#==============================================================================
# Enable/disable skip the splash screen pressing enter
#==============================================================================
CAN_SKIP = true

#==============================================================================
# How much opacity will be incremented per frame.
#==============================================================================
PACE = 5

#==============================================================================
# Rewrite method to the Scene_Splash be called first
#==============================================================================
module SceneManager
   def self.first_scene_class
    $BTEST ? Scene_Battle : Scene_Splash
  end
end

#==============================================================================
# Rewrite method to not replay the music when the scene starts
#==============================================================================
class Scene_Title < Scene_Base
  def play_title_music
  end
end

#==============================================================================
# ** Scene_Splash
#------------------------------------------------------------------------------
#  Create a splash screen
#==============================================================================
class Scene_Splash < Scene_Base
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    SceneManager.clear
    Graphics.freeze
	create_splash
	@index = 0
	@lessOpacity = false
    play_title_music
  end
  
  
  def create_splash
	imgs = SPLASH_IMG_LIST.split(',')
	
    @sprites = []
    imgs.each  do |img|
		sprite = Sprite.new
		sprite.bitmap = Cache.picture(img)
		sprite.opacity = 0
		center_sprite(sprite)
		@sprites.push(sprite)
    end
  end
  
  def update
	super
	if CAN_SKIP
      Input.trigger?(Input::C) ? next_scene : nil
    end
	
	@sprites[@index].opacity += !@lessOpacity ? PACE : -PACE		
	if @sprites[@index].opacity >= 255
		@sprites[@index].opacity = 255
		@lessOpacity = true;
		return;
	end
	
	if @lessOpacity && @sprites[@index].opacity <= 0
		@sprites[@index].opacity = 0
		@index += 1;
		@lessOpacity = false;
		
		if @index >= @sprites.length
			next_scene
		end
	end
  end
  
	def next_scene
		SceneManager.goto(Scene_Title)
	end
  
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    SceneManager.snapshot_for_background
    dispose_splash
  end
  #--------------------------------------------------------------------------
  # * Free Splash
  #--------------------------------------------------------------------------
  def dispose_splash
    @sprites.each  do |sprite|
		sprite.bitmap.dispose
    end

  end
  #--------------------------------------------------------------------------
  # * Move Sprite to Screen Center
  #--------------------------------------------------------------------------
  def center_sprite(sprite)
    sprite.ox = sprite.bitmap.width / 2
    sprite.oy = sprite.bitmap.height / 2
    sprite.x = Graphics.width / 2
    sprite.y = Graphics.height / 2
  end
  #--------------------------------------------------------------------------
  # * Play Title Screen Music
  #--------------------------------------------------------------------------
  def play_title_music
    $data_system.title_bgm.play
    RPG::BGS.stop
    RPG::ME.stop
  end
end
