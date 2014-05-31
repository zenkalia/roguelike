#= require cell

class window.Bat extends LivingThing
  constructor: (cell) ->
    super(cell.x, cell.y, 'B', 'lightgray', 10)
    @light_attack_power = 3
  move_randomly: ->
    is_adjacent = (cell) =>
      d = @distance(cell)
      d < 1.5 and d > 0
    adjacent_cells = window.Game.free_cells.filter is_adjacent
    @.move_to(_.sample(adjacent_cells))
  act: ->
    window.Game.engine.lock()
    @points_this_turn = 5
    go_for_blood = =>
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

      return unless path.length # no path

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
        setTimeout(go_for_blood, 50)
      else
        window.Game.engine.unlock()
    go_for_blood()

