#= require cell

class window.Player extends LivingThing
  action_points: 4
  constructor: (cell) ->
    super(cell.x, cell.y, '@', '#ff0', 50)
    @points_this_turn = @action_points
    $(document).on "keydown", 'body', @handleEvent
    $(document).on "keypress", 'body', @handleEvent
    @acting = false
    @light_attack_power = 2
  act: =>
    @acting = true
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
      @decrement_action_points(1)
      @checkBox()
      window.Game.draw_whole_map()
      return

    return if (!(code of keyMap))

    diff = ROT.DIRS[8][keyMap[code]]
    new_x = @x + diff[0]
    new_y = @y + diff[1]

    new_cell = window.Game.map[new Cell(new_x, new_y).to_s()]
    return unless new_cell

    monster = window.Game.monsters[new_cell.to_s()]
    if monster?
      if window.event.shiftKey
        @heavy_hit monster
        @decrement_action_points 3
      else
        @hit monster
        @decrement_action_points 1
    else
      @.move_to new_cell
      @decrement_action_points 1

    if @points_this_turn < 1
      @acting = false
      window.Game.tick()
      window.Game.engine.unlock()
    window.Game.draw_whole_map()
