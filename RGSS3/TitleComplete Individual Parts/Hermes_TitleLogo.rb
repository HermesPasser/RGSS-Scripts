#==============================================================================
# Hermes TitleLogo
#  by Hermes Passer (hermespasser@gmail.com)
#  gladiocitrico.blogspot.com
#------------------------------------------------------------------------------
#  Shows the a shaking logo.
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

class Scene_Title < Scene_Base
  alias old_create_background create_background
  alias old_terminate 		  terminate
  alias old_update 			  update
  alias old_start 			  start
  
  def start
	old_start
	create_logo
	@current_pixel = 1
	
	@time_to_update = 30
	@current_time_to_update = 0
		
	@direction = ['up', 'down', 'left', 'right']
	@current_direction = 0
	
	@isReturning = false
  end
  
  def update
	old_update
	update_logo_position
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
  
  def terminate
    old_terminate
	@logo.bitmap.dispose
  end

  def create_logo
	@logo = Sprite.new
    @logo.bitmap = Cache.title1(LOGO_IMAGE_NAME)
    center_sprite(@logo)
	@logo.oy += 80
  end
end
