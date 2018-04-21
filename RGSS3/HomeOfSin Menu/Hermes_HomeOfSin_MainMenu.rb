#==============================================================================
# Hermes - Home of Sin - Main Menu
#  by Hermes Passer (hermespasser@gmail.com)
#  gladiocitrico.blogspot.com
#------------------------------------------------------------------------------

#------------------------------------------------------------------
# Vocabulary
#------------------------------------------------------------------

MISSION_TEXT = 'Missões'
COMMAND_WINDOW_Y = 150
#------------------------------------------------------------------
# Class with skin and hero status to be before Window_MenuCommand
#------------------------------------------------------------------
class Window_HeroStatus < Window_Base 

  def initialize(x, y, width, height)
    super(x, y, width, height)
    draw_item 0
  end
  
  def draw_item(index)
    actor = $game_party.members[0]
    enabled = $game_party.battle_members.include?(actor)
    
    rect = Rect.new
    rect.width = 50
    rect.height = 50
    rect.x = 1    
    rect.y = 1
    
    draw_actor_face(actor, rect.x + 1, rect.y + 1, enabled)
    draw_actor_hp(actor, x, 75 + line_height * 1)
    draw_actor_mp(actor, x, 75 + line_height * 2)
  end
end

#------------------
# Rewritten classes
#------------------

class Window_MenuStatus < Window_Selectable
    def draw_item(index)
    actor = $game_party.members[0]
    enabled = $game_party.battle_members.include?(actor)
    
    rect = Rect.new
    rect.width = 50
    rect.height = 50
    rect.x = 1    
    rect.y = 1
    
    draw_actor_name(actor, 1, 1 + line_height * 1)
    draw_actor_hp(actor, 1, 1 + line_height * 2, 300)
    draw_actor_mp(actor, 1, 1 + line_height * 3, 300)
  end

end

class Window_MenuCommand < Window_Command
  def add_main_commands
    add_command(MISSION_TEXT, :mission, defined? HERMES_HOS_MISSION)
    add_command(Vocab::item,  :item)
  end
  
  def add_formation_command; end
  def add_game_end_command;end
  def add_save_command; end
  
  def window_width
    200
  end
  
  def window_height
    Graphics.height
  end
end

class Scene_Menu < Scene_MenuBase  
  def start
    super
    create_command_window
    create_status_window
  end

  def create_status_window
    @status_window = Window_MenuStatus.new(@command_window.width, 0)
    @status_window.width = -(@command_window.width - Graphics.width)
  end
  
  def create_command_window
    @command_window = Window_MenuCommand.new
    @command_window.opacity = 0
    @command_window.y = COMMAND_WINDOW_Y
    @command_window.width -= 40
    @command_window.set_handler(:mission,   method(:goto_scene_mission))
    @command_window.set_handler(:item,      method(:command_item))
    @command_window.set_handler(:cancel,    method(:return_scene))
    @herostatus_window = Window_HeroStatus.new(1, 1, @command_window.width, Graphics.height)
    @herostatus_window.z -= 1
  end
    
  def goto_scene_mission
    SceneManager.call(Scene_Mission)
  end
end