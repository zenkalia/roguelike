#= require cell

class window.Player extends LivingThing
  action_points: 4
  constructor: (cell) ->
    super(cell.x, cell.y, '@', 30)
    @points_this_turn = @action_points
    @acting = false
    @light_attack_power = 2
    @heavy_attack_power = 8
    @inventory = []
    @next_inventory_char = 'a'
    @regen_bank = 0
    @regen_per_turn = .27
    @floor = 0
  bump_inventory_char: =>
    return @next_inventory_char = 'a' if @next_inventory_char == 'z'
    @next_inventory_char = String.fromCharCode(@next_inventory_char.charCodeAt(0) + 1)
  act: =>
    if @hp <= 0
      window.Game.log "You're DEAD!"
      $('body').append($('#death_song').html())
      window.Game.engine.lock()
      window.Game.scheduler.clear()
    else
      @bind_keys()
      @points_this_turn = @action_points
      window.Game.draw_whole_map()
      window.Game.engine.lock()
  decrement_action_points: (points) ->
    @points_this_turn -= points
  bind_keys: =>
    Mousetrap.bind '?', => @print_help()
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
    Mousetrap.bind '/', => @lookup()
    Mousetrap.bind 'space', => @wait()
    Mousetrap.bind '.', => @wait()
    Mousetrap.bind ',', => @pickup()
    Mousetrap.bind 'i', => @show_inventory()
    Mousetrap.bind 'd', => @drop()
    Mousetrap.bind '>', => @descend()

  regen: =>
    @regen_bank += @regen_per_turn
    gain_this_turn = Math.floor @regen_bank
    @hp += gain_this_turn
    @regen_bank -= gain_this_turn
    @hp = _.min [@hp, @max_hp]

  end_of_action: =>
    if (@points_this_turn < @action_points and not window.Game.combat_mode()) or @points_this_turn < 1
      window.Game.tick()
      @rooted = false
      @regen()
      window.Game.engine.unlock()
    else
      @bind_keys()
    window.Game.draw_whole_map()
  print_help: =>
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
                    "> - Descent",
                    "/ - Identify a character",
                    ". - End your turn (also spacebar)",
                    "i - Inventory",
                    "d - Drop",
                    ", - Pick up"].join "\n"
  show_inventory: =>
    window.Game.log ["Inventory:"].concat(_.map @inventory, (item) -> item.to_inventory()).join "\n"

  descend: =>
    Mousetrap.reset()
    if window.Game.stairs.to_s() == @to_s()
      @floor += 1
      window.Game._generate_map()
      @points_this_turn = 0
    else
      window.Game.log 'You see no stairs here'
    @end_of_action()

  wait: =>
    Mousetrap.reset()
    @points_this_turn = 0
    @end_of_action()
  pickup: =>
    Mousetrap.reset()
    @decrement_action_points 1
    item = window.Game.items[@to_s()]
    if item
      window.Game.log "You picked up a #{item.name}."
      delete window.Game.items[@to_s()]
      unless item.inventory_id
        item.inventory_id = @next_inventory_char
        @bump_inventory_char()
      @inventory.push item
    else
      window.Game.log "There's no item to pick up here."
    @end_of_action()

  move: (dx, dy) =>
    Mousetrap.reset()
    new_x = @x + dx
    new_y = @y + dy

    new_cell = window.Game.map[new Cell(new_x, new_y).to_s()]
    return @end_of_action() unless new_cell?.walkable

    @decrement_action_points 1
    monster = window.Game.monsters[new_cell.to_s()]
    if monster?
      damage = @hit monster
      if damage > 0
        window.Game.log "You hit the #{monster.name}."
      else
        window.Game.log "You miss the #{monster.name}."
    else
      if @rooted
        if _.random(1) > .6
          window.Game.log "You break your feet free"
          @rooted = false
        else
          window.Game.log "You can't move with your feet rooted to the ground."
          @end_of_action()
          return
      @.move_to new_cell
      item = window.Game.items[@to_s()]
      window.Game.log "There is a #{item.name} here." if item
    @end_of_action()
  smash: (dx, dy) =>
    Mousetrap.reset()
    new_x = @x + dx
    new_y = @y + dy

    new_cell = window.Game.map[new Cell(new_x, new_y).to_s()]
    return unless new_cell

    monster = window.Game.monsters[new_cell.to_s()]
    if @points_this_turn >= 3
      if monster
        damage = @heavy_hit monster
        @decrement_action_points 3
        if damage > 0
          window.Game.log "You smash the #{monster.name}."
        else
          window.Game.log "You miss the #{monster.name}!"
      else
        window.Game.log 'Who are you trying to attack?'
    else
      window.Game.log 'Not enough action points.'
    @end_of_action()
  drop: =>
    if window.Game.items[@to_s()]
      window.Game.log 'There is something there already.'
      return
    Mousetrap.reset()
    window.Game.log 'What would you like to drop?'
    lookup_callback = (e) =>
      c = String.fromCharCode(e.which)
      selected_item = _.select @inventory, (item) ->
        item.inventory_id == c

      if _.any selected_item
        item = _.first selected_item

        delete @inventory[@inventory.indexOf(item)]
        @inventory = _.compact @inventory
        item.move_to @
        window.Game.log "You dropped #{item.name}."
        window.Game.items[@to_s()] = item
      @acting = true
      $(document).off "keypress", 'body', lookup_callback
      @bind_keys()
    $(document).on "keypress", 'body', lookup_callback
  lookup: =>
    Mousetrap.reset()
    window.Game.log 'What character would you like identified?'
    lookup_callback = (e) =>
      stuff =
        k: 'K - Knobgoblin - a degrogatory term for hobgoblin'
        x: 'X - Gridbug - these electronically based creatures are not native to this universe'
        b: 'B - Bat - the things vampires come from'
        r: 'R - Root Druid - one with nature, watch your footing'
        '%': '% - Stairs'
        '#': '# - Wall'
        '.': '. - Floor'
      msg = stuff[String.fromCharCode(e.which).toLowerCase()]
      if msg
        window.Game.log msg
      else
        window.Game.log 'Never heard of that...'
      @acting = true
      $(document).off "keypress", 'body', lookup_callback
      @bind_keys()
    $(document).on "keypress", 'body', lookup_callback
