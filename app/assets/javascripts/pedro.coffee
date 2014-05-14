#= require cell

class window.Pedro extends Cell
  constructor: (cell) ->
    super(cell.x, cell.y, 'P', 'red')
  act: ->
    target_cell = window.Game.player
    passableCallback = (x, y) ->
      "#{x},#{y}" of window.Game.map # check it's a walkable cell
    astar = new ROT.Path.AStar(target_cell.x, target_cell.y, passableCallback, {topology:4})

    path = []
    pathCallback = (x, y) ->
      path.push(window.Game.map["#{x},#{y}"])
    astar.compute(@x, @y, pathCallback)
    # this isn't checking for enemies.  only walls.

    path.shift() # remove Pedro's position
    if (path.length == 1)
      window.Game.engine.lock()
      alert("Game over - you were captured by Pedro!")
    else
      new_cell = path[0]
      @.move_to(new_cell)
