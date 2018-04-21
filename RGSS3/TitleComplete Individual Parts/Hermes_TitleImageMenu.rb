
# A seta é o que deve ser o que seleciona as opções e dão os comandos.

#==============================================================================
# Hermes TitleImageMenu
#  by Hermes Passer (hermespasser@gmail.com)
#  gladiocitrico.blogspot.com
#------------------------------------------------------------------------------
#  Uses a image as menu.
#==============================================================================

#==============================================================================
# The image name of menu with all options. Must be in Tiles1 folder.
# Example: "options"
#==============================================================================
MENU_IMAGE_NAME = "Opcoes"

#==============================================================================
# The image name of cursor that show the selected option. Must be in Tiles1 folder.
# Example: "cursor"
#==============================================================================
CURSOR_IMAGE_NAME = "Seta"

class Scene_Title < Scene_Base
  alias old_create_command_window create_command_window
  alias old_dispose_background 	  dispose_background
  alias old_update 	 			  update
  alias old_start 	 			  start
  
  def start
	old_start
	create_image_menu
	update_cursor
  end
  
  def update
	old_update
	update_cursor
  end
  
  def update_cursor
	center_sprite(@cursor)
	@cursor.ox += 100
	if @command_window.index == 0
		@cursor.oy -= 50
	elsif  @command_window.index == 1
		@cursor.oy -= 100
	else
		@cursor.oy -= 150
	end
  
  end
  
  def create_image_menu
    @menu = Sprite.new
    @menu.bitmap = Cache.title1(MENU_IMAGE_NAME)
	
    @cursor = Sprite.new
    @cursor.bitmap = Cache.title1(CURSOR_IMAGE_NAME)
    center_sprite(@menu)
	
	@menu.oy -= 100
  end

  def dispose_background
	old_dispose_background
    @menu.bitmap.dispose
    @cursor.bitmap.dispose
  end

  def create_command_window
	old_create_command_window
	@command_window.visible = false
  end
end
