#= require living_thing

class window.Gridbug extends LivingThing
  constructor: (cell) ->
    super(cell.x, cell.y, 'x', 'white', 10)
    @light_attack_power = 2
    @name = 'gridbug'
  act: ->
    window.Game.engine.lock()
    @points_this_turn = 4
    @go_for_blood()
  go_for_blood: =>
    target_cell = window.Game.player
    passableCallback = (x, y) =>
      key = "#{x},#{y}"
      isnt_wall = key of window.Game.map # check it's a walkable cell
      is_monster = key of window.Game.monsters
      isnt_wall and (key == @to_s() or !is_monster)
    astar = new ROT.Path.AStar(target_cell.x, target_cell.y, passableCallback, {topology:4})

    path = []
    pathCallback = (x, y) ->
      path.push(window.Game.map["#{x},#{y}"])
    astar.compute(@x, @y, pathCallback)

    unless path.length # no path
      window.Game.engine.unlock()
      return

    path.shift() # remove Pedro's position
    if @distance(window.Game.player) < 1.1
      if @points_this_turn >= 3
        @heavy_hit(window.Game.player)
        window.Game.log 'The gridbug shocked you!'
        @points_this_turn -= 3
      else
        @hit(window.Game.player)
        window.Game.log 'The gridbug hit you.'
        @points_this_turn -= 1
    else
      new_cell = path[0]
      @.move_to(new_cell)
      @points_this_turn -= 1

    window.Game.draw_whole_map()

    if @points_this_turn > 0
      @end_of_blood()
    else
      window.Game.engine.unlock()
