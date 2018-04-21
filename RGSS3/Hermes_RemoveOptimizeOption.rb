#==============================================================================
# Hermes RemoveOptimizeOption
#  by Hermes Passer (hermespasser@gmail.com)
#  gladiocitrico.blogspot.com
#------------------------------------------------------------------------------
#  Remove the optimize option in equip menu.
#==============================================================================

#---------------
#Remove buttom
#---------------
class Window_EquipCommand < Window_HorzCommand
  def make_command_list
    add_command(Vocab::equip2,   :equip)
    add_command(Vocab::clear,    :clear)
  end
end

#---------------
#Remove function
#---------------
class Scene_Equip < Scene_MenuBase
  def create_command_window
    wx = @status_window.width
    wy = @help_window.height
    ww = Graphics.width - @status_window.width
    @command_window = Window_EquipCommand.new(wx, wy, ww)
    @command_window.viewport = @viewport
    @command_window.help_window = @help_window
    @command_window.set_handler(:equip,    method(:command_equip))
    @command_window.set_handler(:clear,    method(:command_clear))
    @command_window.set_handler(:cancel,   method(:return_scene))
    @command_window.set_handler(:pagedown, method(:next_actor))
    @command_window.set_handler(:pageup,   method(:prev_actor))
  end
end
