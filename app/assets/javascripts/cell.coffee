class window.Cell
  constructor: (@x, @y, @body, @color) ->
  to_s: ->
    "#{@x},#{@y}"
  move_to: (cell) ->
    @x = cell.x
    @y = cell.y
  draw: ->
    window.Game.display.draw(@x, @y, @body, @color)
