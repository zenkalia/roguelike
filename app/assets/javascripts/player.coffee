#= require cell

class window.Player extends LivingThing
  action_points: 4
  constructor: (cell) ->
    super(cell.x, cell.y, '@', '#ff0', 30)
    @points_this_turn = @action_points
    @acting = false
    @light_attack_power = 2
    @heavy_attack_power = 8
  act: =>
    @bind_keys()
    @points_this_turn = @action_points
    window.Game.draw_whole_map()
    window.Game.engine.lock()
  checkBox: ->
    key = @to_s()
    if (window.Game.map[key].body isnt "*")
      alert("There is no box here!")
    else if (key == window.Game.ananas) # this will just be a coordinate string..
      alert("Hooray! You found an ananas and won this game.")
      window.Game.engine.lock()
      window.removeEventListener("keydown", @)
      window.removeEventListener("keypress", @)
    else
      alert "This box is empty :-("
  decrement_action_points: (points) ->
    @points_this_turn -= points
  bind_keys: =>
    Mousetrap.bind '?', =>
      window.Game.log ["Welcome to Mike's roguelike!",
                      "Movement/Combat:",
                      "  y k u  7 8 9",
                      "   \\|/    \\|/",
                      "  h-.-l  4-5-6",
                      "   /|\\    /|\\",
                      "  b j n  1 2 3",
                      "You can use either vimkeys or the numpad to control your character.  The shift modifier allows you to do a smash attack.",
                      "Other:",
                      "? - This help",
                      "/ - Identify a character"].join "\n"
    Mousetrap.bind 'h', => @move(-1, 0)
    Mousetrap.bind 'l', => @move(1, 0)
    Mousetrap.bind 'k', => @move(0, -1)
    Mousetrap.bind 'j', => @move(0, 1)
    Mousetrap.bind 'y', => @move(-1, -1)
    Mousetrap.bind 'u', => @move(1, -1)
    Mousetrap.bind 'b', => @move(-1, 1)
    Mousetrap.bind 'n', => @move(1, 1)
    Mousetrap.bind 'shift+h', => @smash(-1, 0)
    Mousetrap.bind 'shift+l', => @smash(1, 0)
    Mousetrap.bind 'shift+k', => @smash(0, -1)
    Mousetrap.bind 'shift+j', => @smash(0, 1)
    Mousetrap.bind 'shift+y', => @smash(-1, -1)
    Mousetrap.bind 'shift+u', => @smash(1, -1)
    Mousetrap.bind 'shift+b', => @smash(-1, 1)
    Mousetrap.bind 'shift+n', => @smash(1, 1)
    Mousetrap.bind 'left',     => @move(-1, 0)
    Mousetrap.bind 'right',    => @move(1, 0)
    Mousetrap.bind 'up',       => @move(0, -1)
    Mousetrap.bind 'down',     => @move(0, 1)
    Mousetrap.bind 'home',     => @move(-1, -1)
    Mousetrap.bind 'pageup',   => @move(1, -1)
    Mousetrap.bind 'end',      => @move(-1, 1)
    Mousetrap.bind 'pagedown', => @move(1, 1)
    Mousetrap.bind 'shift+left',     => @smash(-1, 0)
    Mousetrap.bind 'shift+right',    => @smash(1, 0)
    Mousetrap.bind 'shift+up',       => @smash(0, -1)
    Mousetrap.bind 'shift+down',     => @smash(0, 1)
    Mousetrap.bind 'shift+home',     => @smash(-1, -1)
    Mousetrap.bind 'shift+pageup',   => @smash(1, -1)
    Mousetrap.bind 'shift+end',      => @smash(-1, 1)
    Mousetrap.bind 'shift+pagedown', => @smash(1, 1)
    Mousetrap.bind '4', => @move(-1, 0)
    Mousetrap.bind '6', => @move(1, 0)
    Mousetrap.bind '8', => @move(0, -1)
    Mousetrap.bind '2', => @move(0, 1)
    Mousetrap.bind '7', => @move(-1, -1)
    Mousetrap.bind '9', => @move(1, -1)
    Mousetrap.bind '1', => @move(-1, 1)
    Mousetrap.bind '3', => @move(1, 1)
    Mousetrap.bind 'shift+4', => @smash(-1, 0)
    Mousetrap.bind 'shift+6', => @smash(1, 0)
    Mousetrap.bind 'shift+8', => @smash(0, -1)
    Mousetrap.bind 'shift+2', => @smash(0, 1)
    Mousetrap.bind 'shift+7', => @smash(-1, -1)
    Mousetrap.bind 'shift+9', => @smash(1, -1)
    Mousetrap.bind 'shift+1', => @smash(-1, 1)
    Mousetrap.bind 'shift+3', => @smash(1, 1)

  end_of_action: =>
    if @points_this_turn < 1
      Mousetrap.reset()
      window.Game.tick()
      window.Game.engine.unlock()
    window.Game.draw_whole_map()
  move: (dx, dy) =>
    new_x = @x + dx
    new_y = @y + dy

    new_cell = window.Game.map[new Cell(new_x, new_y).to_s()]
    return unless new_cell

    monster = window.Game.monsters[new_cell.to_s()]
    if monster?
      @hit monster
      window.Game.log "You hit the #{monster.name}."
      @decrement_action_points 1
    else
      @.move_to new_cell
      @decrement_action_points 1
    @end_of_action()
  smash: (dx, dy) =>
    new_x = @x + dx
    new_y = @y + dy

    new_cell = window.Game.map[new Cell(new_x, new_y).to_s()]
    return unless new_cell

    monster = window.Game.monsters[new_cell.to_s()]
    if @points_this_turn >= 3
      @heavy_hit monster
      @decrement_action_points 3
    else
      window.Game.log "Not enough action points."
    @end_of_action()


  handleEvent: (e) =>
    return unless @acting
    if e.type == 'keypress'
      keyMap = {
        # uppercase vim keys here
        75: 0
        85: 1
        76: 2
        78: 3
        74: 4
        66: 5
        72: 6
        89: 7
        107: 0
        117: 1
        108: 2
        110: 3
        106: 4
        98:  5
        104: 6
        121: 7
      }

    if e.type == 'keydown'
      keyMap = {
        38: 0
        33: 1
        39: 2
        34: 3
        40: 4
        35: 5
        37: 6
        36: 7
      }

    code = e.keyCode

    if (e.type is 'keypress' and (code == 13 or code == 32))
      @decrement_action_points 1
      @checkBox()
      window.Game.draw_whole_map()

    if e.type is 'keypress' and code == 47
      @acting = false
      window.Game.log 'What character would you like identified?'
      lookup_callback = (e) =>
        stuff =
          K: 'Knobgoblin - a degrogatory term for hobgoblin.'
          x: 'Gridbug - these electronically based creatures are not native to this universe.'
          B: 'Bat - the things vampires come from'
        msg = stuff[String.fromCharCode(e.which)]
        if msg
          window.Game.log msg
        else
          window.Game.log 'Never heard of that...'
        @acting = true
        $(document).off "keypress", 'body', lookup_callback
      $(document).on "keypress", 'body', lookup_callback

    if code of keyMap
      diff = ROT.DIRS[8][keyMap[code]]
      new_x = @x + diff[0]
      new_y = @y + diff[1]

      new_cell = window.Game.map[new Cell(new_x, new_y).to_s()]
      return unless new_cell

      monster = window.Game.monsters[new_cell.to_s()]
      if monster?
        if window.event.shiftKey
          if @points_this_turn >= 3
            @heavy_hit monster
            @decrement_action_points 3
          else
            window.Game.log "Not enough action points."
        else
          @hit monster
          window.Game.log "You hit the #{monster.name}."
          @decrement_action_points 1
      else
        @.move_to new_cell
        @decrement_action_points 1

    if @points_this_turn < 1
      @acting = false
      window.Game.tick()
      window.Game.engine.unlock()
    window.Game.draw_whole_map()
