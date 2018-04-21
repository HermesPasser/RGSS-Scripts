#==============================================================================
# Hermes Home of Sin Alt Menu
#  by Hermes Passer (hermespasser@gmail.com)
#  gladiocitrico.blogspot.com
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Vocabulary
#------------------------------------------------------------------------------
TEXT_RETURN = 'Voltar'
TEXT_OPTION = 'Opções'
TEXT_EXIT   = 'Sair'

# Override 
class Scene_Map < Scene_Base
  alias old_update update
  def update
    old_update
    # A buttom
    Input.trigger?(:X) ? SceneManager.call(Scene_AltMenu) : 0
  end
end

# Override
class Window_GameEnd < Window_Command
  def make_command_list
    add_command(Vocab::shutdown, :shutdown)
    add_command(Vocab::cancel,   :cancel)
  end
end

class Scene_AltMenu < Scene_Base
 def start
    super
    create_background
    create_window
  end
  
  def create_window
    @altwindow = Window_AltMenu.new(Graphics.width / 2, Graphics.height / 2)
    @altwindow.set_handler(:cancel,  method(:return_scene))
    @altwindow.set_handler(:return,  method(:return_scene))
    @altwindow.set_handler(:option,  method(:option))
    @altwindow.set_handler(:save,    method(:command_save))
    @altwindow.set_handler(:exit,    method(:exit))
  end
  
  def option
    SceneManager.call(Scene_Option)
  end
  
  def command_save
    SceneManager.call(Scene_Save)
  end
  
  def exit
    SceneManager.call(Scene_End)
  end
  
  def dispose
    super
    dispose_background
  end
  
  def dispose_background
    @background_sprite.dispose
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
end


class Window_AltMenu < Window_Command
  def initialize(x, y)
    super(x - 50, y - 125 / 2)
  end

  def make_command_list
    add_command(TEXT_RETURN, :return)
    add_command(TEXT_OPTION, :option, defined? HERMES_HOS_OPTION)
    add_command(Vocab::save, :save,   !$game_system.save_disabled)
    add_command(TEXT_EXIT,   :exit)
  end
  
  def window_width
    100
  end
  
  def window_height
    125
  end
end