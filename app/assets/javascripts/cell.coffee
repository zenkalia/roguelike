class window.Cell
  constructor: (@x, @y, @body, @color) ->
  to_s: ->
    "#{@x},#{@y}"
  move_to: (cell) ->
    @x = cell.x
    @y = cell.y
  draw: ->
    window.Game.display.draw(@x, @y, @body, @color)

class window.LivingThing extends Cell
  constructor: (@x, @y, @body, @color, @hp) ->
    @max_hp = @hp
  move_to: (cell) ->
    monster = window.Game.monsters[@to_s()]
    delete window.Game.monsters[@to_s()] if monster? and monster == @
    super(cell)
    window.Game.monsters[@to_s()] = @ if monster? and monster == @
