#==============================================================================
# Hermes - Home of Sin - Item Menu
#  by Hermes Passer (hermespasser@gmail.com)
#  gladiocitrico.blogspot.com
#------------------------------------------------------------------------------
# Need of Hermes Home of Sin Main Menu above to work
#------------------------------------------------------------------------------

class Scene_Item < Scene_ItemBase
  alias old_start start
  def start
    old_start
    resize_windows
  end
  
  def resize_windows
    @herostatus_window = Window_HeroStatus.new(1, 1, COMMAND_WINDOW_Y, Graphics.height)
    
    @category_window.x = COMMAND_WINDOW_Y
    @item_window.x     = COMMAND_WINDOW_Y
    @help_window.x     = COMMAND_WINDOW_Y

    @category_window.width = -(COMMAND_WINDOW_Y - Graphics.width)
    @item_window.width     = -(COMMAND_WINDOW_Y - Graphics.width)
    @help_window.width     = -(COMMAND_WINDOW_Y - Graphics.width)
  end
end

class Window_ItemCategory < Window_HorzCommand
  def window_width
    Graphics.width - 150
  end
end
