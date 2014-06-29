class window.Cell
  constructor: (@x, @y, @body, color) ->
    @__color = color
  color: ->
    @__color
  to_s: ->
    "#{@x},#{@y}"
  move_to: (cell) ->
    @x = cell.x
    @y = cell.y
  draw: ->
    window.Game.display.draw(@x, @y + window.Game.y_offset, @body, @color())
  distance: (cell) ->
    dx = _.abs(@x - cell.x)
    dy = _.abs(@y - cell.y)
    lateral = _.abs(dx - dy)
    diagonal = _.max([dx, dy]) - lateral
    lateral + diagonal * 1.4
