#=====================================================
# Wolf Menu for RMXP 0.1
#  by Hermes Passer (hermespasser@gmail.com)
#  gladiocitrico.blogspot.com | hermespasser.github.io
#-----------------------------------------------------
# EN: An alternative menu that:
#   - uses a image in pictures as character graphics. If it
# exists. If not use the default character graphic.
#   - add a animation to the windows;
#   - add a custom opacity to the windows;
#   - add a margin to the status windows;
#   - resize the the status window to fit of the number of 
# characters in the party;
#   - add a background image;
#   - change the status order and add a separator in between
# the character names and it classes;
#   - remove the windows "time played" and "steps walked".
#
# PT: Um menu alternativo que:
#   - usa uma imagem em pictures como gráfico do personagem
# Se ela não existir então usa a imagem padrão de gráfico do personagem;
#   - adiciona uma animação para as janelas;
#   - adiciona uma opacidade customizável para as janelas;
#   - adiciona uma margem para a window de status;
#   - redimensiona a janela de status para ficar no tamanho
# referente ao número de personagens na equipe;
#   - adiciona uma imagem de fundo;
#   - muda a ordem dos status e adiciona um separador entre o
# nome do personagem e sua classe;
#   - remove as janelas "tempo jogado" e "paços percorridos".
#-----------------------------------------------------

#-------------
# EN: Background image name without extension. Must be in pictures folder.
# PT: Nome da imagem de fundo sem a extensão. Deve estar na pasta pictures.
#-------------
$BACKGROUND_IMAGE = 'background'

#-------------
# EN: Text in between character name and it class.
# PT: Texto que separa o nome do character de sua classe.
#-------------
$CLASS_SEPARATOR = ' the '

#-------------
# EN: Window opacity. Maximum 255, minimum 0.
# PT: Opacidade das janelas. Máximo 255, mínimo 0.
#-------------
$WINDOW_OPACITY = 100

#-------------
# EN: Frames per frame in the animation.
# PT: Píxeis percorridos por frame na animação.
#-------------
$PIXELS_PER_FRAME = 5

#-------------
# EN: Window status margin in x.
# PT: Margem da janela de status em x.
#-------------
$STATS_MARGIN_X = 5

#-------------
# EN: Window status margin in y.
# PT: Margem da janela de status em y.
#-------------
$STATS_MARGIN_Y = 5

#-------------
# EN: Do not change anything below.
# PT: Não altere nada abaixo.
#-------------

$ANIMATION_ENABLED = true

class Window_MenuStatus < Window_Selectable
  alias old_update update  
  
  def initialize
    super($STATS_MARGIN_X, $STATS_MARGIN_Y, 400, 117 * $game_party.actors.length)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.name = $fontface
    self.contents.font.size = $fontsize
    self.opacity = $WINDOW_OPACITY
    refresh
    self.active = false
    self.index = -1
    
    @sprite = Sprite.new
    @sprite.bitmap = RPG::Cache.picture($BACKGROUND_IMAGE)
        
    $ANIMATION_ENABLED == true ? self.x = 643 : self.x = 160 + $STATS_MARGIN_X
  end
  
  def dispose
    if @sprite != nil
        @sprite.dispose
        @sprite.bitmap.dispose
    end
    super
  end
    
  # Draw the actor face, if face not exits then draw character
  def draw_actor_graphic(actor, x, y)
    begin
      bitmap = RPG::Cache.picture(actor.character_name)
      cw = bitmap.width
      ch = bitmap.height
      src_rect = Rect.new(0, 0, 64, 64)
    rescue Errno::ENOENT
      bitmap = RPG::Cache.character(actor.character_name, actor.character_hue)
      cw = bitmap.width / 4
      ch = bitmap.height / 4
      src_rect = Rect.new(0, 0, cw, ch)
    end    

    self.contents.blt(x - cw / 2, y - ch, bitmap, src_rect)
  end
  
  # Draw all status
  def draw_stats(actor, x, y)
    draw_actor_graphic(actor, x - 40, y + 80)
    
    # Name and Class
    nameAndClass = "#{actor.name}#{$CLASS_SEPARATOR}#{actor.class_name}"
    self.contents.font.color = normal_color
    self.contents.draw_text(x, y, 350, 32, nameAndClass)
    
    # HP
    tX = x; tY = y + 30; tW = 120; tH = 32 
    hp = "#{actor.hp.to_s} / #{actor.maxhp.to_s}"
    self.contents.font.color = system_color
    self.contents.draw_text(tX, tY, tW, tH, $data_system.words.hp)
    self.contents.font.color = actor.hp == 0 ? knockout_color :
      actor.hp <= actor.maxhp / 4 ? crisis_color : Color.new(0, 255, 0)
    tX = tX + 30;
    self.contents.draw_text(tX, tY, tW, tH, hp)

    # MP
    tX = tX + 120
    mp = "#{actor.sp.to_s} / #{actor.maxsp.to_s}"
    self.contents.font.color = system_color
    self.contents.draw_text(tX, tY, tW, tH, $data_system.words.sp)
    self.contents.font.color = actor.sp == 0 ? knockout_color :
      actor.sp <= actor.maxsp / 4 ? crisis_color : Color.new(0, 0, 255)
    tX = tX + 30;
    self.contents.draw_text(tX, tY, tW, tH, mp)
    
    # Level and EXP
    tX = x; tY = tY + 30
    xp = "#{actor.level.to_s} (#{actor.exp_s}/#{actor.next_exp_s})"
    self.contents.font.color = system_color
    self.contents.draw_text(tX, tY, tW, tH, 'Lv.')
    tX = tX + 30;
    self.contents.font.color = normal_color
    self.contents.draw_text(tX, tY, tW, tH, xp)
    
    #State
    tX = tX + 120
    text = make_battler_state_text(actor, width, true)
    self.contents.font.color = actor.hp == 0 ? knockout_color : normal_color
    self.contents.draw_text(tX, tY, tW, tH, text)  
  end
  
  def refresh
    self.contents.clear
    @item_max = $game_party.actors.size
    for i in 0...$game_party.actors.size
      x = 64
      y = i * 116
      draw_stats($game_party.actors[i], x, y)
    end
  end
  
  def update
    old_update
    self.x > 160 + $STATS_MARGIN_X ? self.x -= $PIXELS_PER_FRAME * 2 : 0
  end
end

class Window_Gold < Window_Base
  alias old_initialize initialize
  alias old_update update

  def initialize
    old_initialize
    $ANIMATION_ENABLED == true ? self.x = -160 : self.x = 0 
    self.opacity = $WINDOW_OPACITY
    self.y = 416
  end

  def update
    old_update
    self.x < 0 ? self.x += $PIXELS_PER_FRAME : 0
  end
end

class Window_Command < Window_Selectable
  alias old_initialize initialize
  alias old_update update unless $@

  def initialize(width, commands)
    old_initialize(width, commands)
    
    $ANIMATION_ENABLED == true ? self.x = -160 : self.x = 0 
    if $scene.class != Scene_Title
       self.opacity = $WINDOW_OPACITY
    end
  end

  def update
    old_update
    self.x < 0 ? self.x += $PIXELS_PER_FRAME : 0
  end
end

class Scene_Menu  
  def main
    s1 = $data_system.words.item
    s2 = $data_system.words.skill
    s3 = $data_system.words.equip
    s4 = "Status"
    s5 = "Salvar"
    s6 = "Fim de Jogo"
    
    @command_window = Window_Command.new(160, [s1, s2, s3, s4, s5, s6])
    @command_window.index = @menu_index
    
    # Se o número de membros do Grupo de Heróis for 0 desabilar as janelas 
    if $game_party.actors.size == 0
      @command_window.disable_item(0)
      @command_window.disable_item(1)
      @command_window.disable_item(2)
      @command_window.disable_item(3)
    end
    
    if $game_system.save_disabled
      @command_window.disable_item(4)
    end
    
    @gold_window = Window_Gold.new
    @status_window = Window_MenuStatus.new

    Graphics.transition
    # Loop principal
    loop do
      # Atualizar a tela de jogo
      Graphics.update
      Input.update
      update
      update_animation

      # Abortar loop se a tela for alterada
      if $scene != self
        break
      end
    end
    # Preparar para transiçõa
    Graphics.freeze

    @command_window.dispose
    @gold_window.dispose
    @status_window.dispose
  end
  
  def update
    @command_window.update
    @gold_window.update
    @status_window.update
    
    if @command_window.active then update_command and return end
    if @status_window.active then update_status and return end
  end
    
  def update_animation
    if Input.trigger?(Input::B) then $ANIMATION_ENABLED = true end
    if Input.trigger?(Input::C) then $ANIMATION_ENABLED = false end
  end
end
