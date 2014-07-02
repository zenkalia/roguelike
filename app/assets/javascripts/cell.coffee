class window.Cell
  constructor: (@x, @y, @body, color) ->
    @__color = color
    @walkable = true
  color: ->
    @__shade_color(@__color, @distance(window.Game.player) * 2)
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

  __shade_color: (color, percent) ->
    R = parseInt(color.substring(1,3),16)
    G = parseInt(color.substring(3,5),16)
    B = parseInt(color.substring(5,7),16)

    R = parseInt(R * (100 - percent) / 100)
    G = parseInt(G * (100 - percent) / 100)
    B = parseInt(B * (100 - percent) / 100)

    R = if R<255 then R else 255
    G = if G<255 then G else 255
    B = if B<255 then B else 255

    RR = if (R.toString(16).length==1) then "0"+R.toString(16) else R.toString(16)
    GG = if (G.toString(16).length==1) then "0"+G.toString(16) else G.toString(16)
    BB = if (B.toString(16).length==1) then "0"+B.toString(16) else B.toString(16)

    "#"+RR+GG+BB
