#==============================================================================
# Hermes TitleComplete
#  by Hermes Passer (hermespasser@gmail.com)
#  gladiocitrico.blogspot.com
#------------------------------------------------------------------------------
#  The sum of Hermes_TitleImageMenu, Hermes_TitleParallax and Hermes_TitleLogo
#==============================================================================

#==============================================================================
# The image name. Must be in Titles1 folder.
# Example: "logo1"
#==============================================================================
LOGO_IMAGE_NAME = "NameGame"

#==============================================================================
# Number of pixels to move in all directions
#==============================================================================
PIXELS_TO_MOVE = 3

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
  alias old_create_command_window 	create_command_window
  alias old_terminate 	terminate
  alias old_update 		update
  alias old_start 		start
  
  def start
	old_start
	start_logo
	create_logo
	create_image_menu
	update_cursor
  end
  
  def start_logo
	@current_pixel = 1
	@isReturning = false
	
	@time_to_update = 30
	@current_time_to_update = 0
		
	@direction = ['up', 'down', 'left', 'right']
	@current_direction = 0
  end
  
  def update
	old_update
	update_parallax
	update_logo_position
	update_cursor
  end
  
  def update_parallax
	@sprite1.ox -= 1
  end
  
  def update_logo_position
	@current_time_to_update += 1
	
	if @current_time_to_update >= @time_to_update		
		case @direction[@current_direction]
		when "up"    
			@logo.ox += @isReturning ? 1 : -1
		when "left"  
			@logo.oy += @isReturning ? 1 : -1
		when "down"  
			@logo.ox -= @isReturning ? 1 : -1
		when "right" 
			@logo.oy -= @isReturning ? 1 : -1
		end
				
		@current_pixel += 1
		@current_time_to_update = 0
		if @isReturning and @current_pixel >= PIXELS_TO_MOVE
			@current_direction = (@current_direction + 1) % @direction.length
		end
	end

	if @current_pixel >= PIXELS_TO_MOVE
		@isReturning  = !@isReturning 
		@current_pixel = 1
	end
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
  
  def terminate
    old_terminate
	terminate_logo
  end

  def terminate_logo
	@logo.bitmap.dispose
  end
  
  def create_background
    @position = Viewport.new(0, 0, 1000, 500)
    @sprite1 = Plane.new(@position)
    @sprite1.bitmap = Cache.title1($data_system.title1_name)
	
    @sprite2 = Sprite.new
    @sprite2.bitmap = Cache.title2($data_system.title2_name)
    center_sprite(@sprite2)
  end
  
  def create_logo
	@logo = Sprite.new
    @logo.bitmap = Cache.title1(LOGO_IMAGE_NAME)
    center_sprite(@logo)
	@logo.oy += 80
  end
  
  def create_image_menu
    @menu = Sprite.new
    @menu.bitmap = Cache.title1(MENU_IMAGE_NAME)
	
    @cursor = Sprite.new
    @cursor.bitmap = Cache.title1(CURSOR_IMAGE_NAME)
    center_sprite(@menu)
	
	@menu.oy -= 100
  end
  
  def create_command_window
	old_create_command_window
	@command_window.visible = false
  end
end
