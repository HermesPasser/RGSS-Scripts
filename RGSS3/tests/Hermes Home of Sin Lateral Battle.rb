#==============================================================================
# Hermes Home of Sin Lateral Battle (or just pop up the actor in scene)
#  by Hermes Passer (hermespasser@gmail.com)
#  gladiocitrico.blogspot.com
#------------------------------------------------------------------------------

class Scene_Battle < Scene_Base
  def start
    super
    create_spriteset
    create_all_windows
    BattleManager.method_wait_for_message = method(:wait_for_message)
    
    @tet = Window_CharacterInBattle.new(1,1,Graphics.width, Graphics.height)
    @tet.opacity = 0
  end
  
end


class Window_CharacterInBattle < Window_Base
  def initialize(x, y, width, height)
    super
    draw_character($game_player.character_name, $game_player.character_index,
                  Graphics.width - 32, Graphics.height / 2 - 32)
  end
  
  def draw_character(character_name, character_index, x, y)
    return unless character_name
    bitmap = Cache.character(character_name)
    sign = character_name[/^[\!\$]./]
    if sign && sign.include?('$')
      cw = bitmap.width / 3
      ch = bitmap.height / 4
    else
      cw = bitmap.width / 12
      ch = bitmap.height / 8
    end
    n = character_index
    src_rect = Rect.new((n%4*3+1)*cw, (n/4*4)*ch, cw, ch)
    src_rect.y += 32
    contents.blt(x - cw / 2, y - ch, bitmap, src_rect)
  end

end