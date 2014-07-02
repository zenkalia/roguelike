#= require cell

class window.Wall extends Cell
  constructor: (@x, @y, color) ->
    @body = '#'
    @__color = color
    @walkable = false
