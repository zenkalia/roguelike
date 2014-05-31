#= require living_thing

class window.Bat extends LivingThing
  constructor: (cell) ->
    super(cell.x, cell.y, 'B', 'lightgray', 10)
    @light_attack_power = 3
  move_randomly: ->
    is_adjacent = (cell) =>
      d = @distance(cell)
      is_player = window.Game.player.to_s() == cell.to_s()
      is_monster = cell.to_s() of window.Game.monsters
      d < 1.5 and d > 0 and not is_player and not is_monster
    adjacent_cells = window.Game.free_cells.filter is_adjacent
    @.move_to(_.sample(adjacent_cells)) if adjacent_cells.length > 1
  act: ->
    window.Game.engine.lock()
    @points_this_turn = 5
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
    if @points_this_turn > 2
      @move_randomly()
      @points_this_turn -= 1
    else if @distance(window.Game.player) < 2
        @hit(window.Game.player)
        window.Game.log 'The bat bit you.'
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

