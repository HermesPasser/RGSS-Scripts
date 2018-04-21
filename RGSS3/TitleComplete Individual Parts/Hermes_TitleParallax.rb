#==============================================================================
# Hermes TitleParalax
#  by Hermes Passer (hermespasser@gmail.com)
#  gladiocitrico.blogspot.com
#------------------------------------------------------------------------------
#  Change title 1 image to a parallax.
#==============================================================================

class Scene_Title < Scene_Base
  def update
	super
	@sprite1.ox -= 1
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background	
    @position = Viewport.new(0, 0, 1000, 500)
    @sprite1 = Plane.new(@position)
    @sprite1.bitmap = Cache.title1($data_system.title1_name)
	
    @sprite2 = Sprite.new
    @sprite2.bitmap = Cache.title2($data_system.title2_name)
    center_sprite(@sprite2)
  end
end
