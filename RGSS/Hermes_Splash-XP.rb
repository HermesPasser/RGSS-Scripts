#==============================================================================
# Hermes TitleSplash XP 0.1
#  by Hermes Passer (hermespasser@gmail.com)
#  gladiocitrico.blogspot.com
#------------------------------------------------------------------------------
#  functionalities:
#	-	Show a splash screen before the title screen and you can skip pressing enter (C).
#
#  To make it works you need change the line "$scene = Scene_Title.new" with
#  "$scene = Scene_Splash.new" in Main script.
#==============================================================================

#==============================================================================
# Add the images here separated by ','. All images must be in pictures folder.
# Not use space (' ') after the ',' to separate the images.
# example: "imageone, image two, the third one"
#==============================================================================
SPLASH_IMG_LIST = "Produção-TNS,TNS Wolf,Hermes Passer"

#==============================================================================
# Enable/disable skip the splash screen pressing enter
#==============================================================================
CAN_SKIP = true

#==============================================================================
# How much opacity will be incremented per frame.
#==============================================================================
PACE = 5

#==============================================================================
# ** Scene_Splash
#------------------------------------------------------------------------------
#  Create a splash screen
#==============================================================================
class Scene_Splash
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def main
    @index = 0
    @lessOpacity = false
    create_splash
    
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    dispose_splash 
  end
  
  def create_splash
    imgs = SPLASH_IMG_LIST.split(',')
    @sprites = []
    imgs.each  do |img|
		sprite = Sprite.new
		sprite.bitmap = RPG::Cache.picture(img)
		sprite.opacity = 0
		center_sprite(sprite)
		@sprites.push(sprite)
    end
  end
  
  def dispose_splash
    @sprites.each  do |sprite|
      sprite.bitmap.dispose
      sprite.dispose
    end
  end
  
  def update
    if CAN_SKIP
      Input.trigger?(Input::C) ? next_scene : nil
    end
    @sprites[@index].opacity += !@lessOpacity ? PACE : -PACE; 
    if @sprites[@index].opacity >= 255
      @sprites[@index].opacity = 255;
      @lessOpacity = true;
      return;
    end
    
    if @lessOpacity && @sprites[@index].opacity <= 0
      @sprites[@index].opacity = 0;
      @index += 1;
      @lessOpacity = false;
      
      if @index >= @sprites.length
        next_scene
      end
    end
  end
  
  def next_scene
    $scene = Scene_Title.new;
  end
  
  #--------------------------------------------------------------------------
  # * Move Sprite to Screen Center
  #--------------------------------------------------------------------------
  def center_sprite(sprite)
    sprite.ox = sprite.bitmap.width / 2
    sprite.oy = sprite.bitmap.height / 2
    sprite.x = 640 / 2
    sprite.y = 480 / 2
  end
end
