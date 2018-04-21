#==============================================================================
# Hermes Home of Sin Mission Menu
#  by Hermes Passer (hermespasser@gmail.com)
#  gladiocitrico.blogspot.com
#------------------------------------------------------------------------------
# Need of Hermes Home of Sin Main Menu above to work
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# All missions are stored here
#------------------------------------------------------------------------------
$missions = {}

#------------------------------------------------------------------------------
# Vocabulary
#------------------------------------------------------------------------------
TEXT_MISSION = 'Missão'
TEXT_DESC    = 'Descrição'
TEXT_REWARD  = 'Recompensa'
TEXT_STATUS  = 'Status'

#------------------------------------------------------------------------------
# Flag to Mission option in Menu  will be enabled.
#------------------------------------------------------------------------------
HERMES_HOS_MISSION = 0

class Mission
  attr_accessor :name
  attr_accessor :desc
  attr_accessor :reward
  attr_accessor :status
  
  def initialize(name, desc, reward, status)
    @name = name
    @desc = desc
    @reward = reward
    @status = status
  end
  
  def self.add(name, desc, reward, status)
    item = Mission.new(name, desc, reward, status)
    $missions[name] = item
  end
  
  def self.update_desc(name, desc)
    if $missions[name] == nil
      puts "Hermes Mission: #{name} not found."
      return
    end
    $missions[name].desc = desc
  end

  def self.update_reward(name, reward)
    if $missions[name] == nil
      puts "Hermes Mission: #{name} not found."
      return
    end
    $missions[name].reward = reward
  end
  
  def self.update_status(name, status)
    if $missions[name] == nil
      puts "Hermes Mission: #{name} not found."
      return
    end
    $missions[name].status = status
  end
  
  def self.remove(name)
    if $missions[name] == nil
      puts "Hermes Mission: #{name} not found."
      return
    end
    $missions.delete(name)
  end
end

class Scene_Mission < Scene_Base
 def start
    super
    create_background
    create_windows
  end
  
  def create_windows
    @herostatus_window = Window_HeroStatus.new(1, 1, COMMAND_WINDOW_Y, Graphics.height)
    @gwindow = MissionWindow.new()
    @gwindow.set_handler(:cancel, method(:return_scene))
  end

  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def dispose
    super
    @background_sprite.bitmap.dispose
  end
end

class MissionWindow < Window_Command
  def initialize()
    super(COMMAND_WINDOW_Y, 1)
  end
 
  def make_command_list
    $missions.each_key do |key|
      text = "#{TEXT_MISSION}: #{$missions[key].name}"
      add_command(text, :none)
      text = "#{TEXT_DESC}: #{$missions[key].desc}"
      add_command(text, :none)
      text = "#{TEXT_REWARD}: #{$missions[key].reward}"
      add_command(text, :none)
      text = "#{TEXT_STATUS}: #{$missions[key].status}"
      add_command(text, :none)
      add_command('', :none)
    end
  end
  
  def window_width
    -(COMMAND_WINDOW_Y - Graphics.width)
  end
  
  def window_height
    Graphics.height
  end
end