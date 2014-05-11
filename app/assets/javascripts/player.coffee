#= require cell

class window.Player extends Cell
  action_points: 4
  constructor: (cell) ->
    @body = '@'
    @color = '#ff0'
    @.move_to(cell)
  act: =>
    window.Game.engine.lock()
    @points_this_turn = @action_points
    window.Game.display.drawText(77, 26, String(@points_this_turn))
    window.addEventListener("keydown", @)
    window.addEventListener("keypress", @)
  checkBox: =>
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
  handleEvent: (e) ->
    if e.type == 'keypress'
      keyMap = {
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
      @checkBox()
      return

    return if (!(code of keyMap))

    alert 'SHIFTY' if window.event.shiftKey

    diff = ROT.DIRS[8][keyMap[code]]
    new_x = @x + diff[0]
    new_y = @y + diff[1]

    new_cell = window.Game.map[new Cell(new_x, new_y).to_s()]
    return unless new_cell

    window.Game.map[@to_s()].draw()
    @.move_to(new_cell)
    @.draw()
    window.removeEventListener("keydown", @)
    @points_this_turn--
    window.Game.display.drawText(77, 26, String(@points_this_turn))

    window.Game.engine.unlock() if @points_this_turn < 1
