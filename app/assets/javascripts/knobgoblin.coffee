#= require living_thing

class window.Knobgoblin extends LivingThing
  constructor: (cell) ->
    super(cell.x, cell.y, 'K', 'pink', 20)
    @light_attack_power = 1
    @heavy_attack_power = 15
    @name = 'knobgoblin'
  act: ->
    return unless @aggro
    window.Game.engine.lock()
    @points_this_turn = 2
    @go_for_blood()
  go_for_blood: =>
    target_cell = window.Game.player
    passableCallback = (x, y) =>
      key = "#{x},#{y}"
      isnt_wall = key of window.Game.map # check it's a walkable cell
      is_monster = key of window.Game.monsters
      isnt_wall and (key == @to_s() or !is_monster)
    astar = new ROT.Path.AStar(target_cell.x, target_cell.y, passableCallback, {topology:8})

    path = []
    pathCallback = (x, y) ->
      path.push(window.Game.map["#{x},#{y}"])
    astar.compute(@x, @y, pathCallback)

    unless path.length # no path
      window.Game.engine.unlock()
      return

    path.shift() # remove Pedro's position
    if @distance(window.Game.player) < 2
      if @points_this_turn >= 2
        @heavy_hit(window.Game.player)
        window.Game.log "The #{@name} smashed you!"
        @points_this_turn -= 2
      else
        @hit(window.Game.player)
        window.Game.log "The #{@name} hit you."
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
