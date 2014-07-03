#= require cell

class window.Stairs extends Cell
  constructor: (cell) ->
    @x = cell.x
    @y = cell.y
    @__color = '#ffffff'
    @body = '%'
    @walkable = true
