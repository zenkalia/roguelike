#= require living_thing

class window.Monster extends LivingThing
  curious_about: ->
    @__curious_about = null if @__curious_about?.to_s() == @to_s()
    @__curious_about ||= _.sample window.Game.free_cells
  act: ->
    unless @aggro
      @step_toward(@curious_about())
    else
      window.Game.engine.lock()
      @points_this_turn = @action_points
      @go_for_blood()
  topology: 8
  step_toward: (target_cell) ->
    passableCallback = (x, y) =>
      key = "#{x},#{y}"
      isnt_wall = window.Game.map[key]?.walkable
      is_monster = key of window.Game.monsters
      isnt_wall and (key == @to_s() or !is_monster)
    astar = new ROT.Path.AStar(target_cell.x, target_cell.y, passableCallback, {topology: @topology})

    path = []
    pathCallback = (x, y) ->
      path.push(window.Game.map["#{x},#{y}"])
    astar.compute(@x, @y, pathCallback)

    return false unless path.length # no path

    path.shift()
    new_cell = path[0]
    @.move_to(new_cell)
  hop_toward: (target_cell) ->
    coord_candidates = []
    coord_candidates.push [-2, -1]
    coord_candidates.push [-2, +1]
    coord_candidates.push [-1, -1]
    coord_candidates.push [-1, +1]
    coord_candidates.push [+2, -1]
    coord_candidates.push [+2, +1]
    coord_candidates.push [+1, -2]
    coord_candidates.push [+1, +2]

    candidates = []

    _.map coord_candidates, (coord) =>
      candidate = new Cell(@.x + coord[0], @.y + coord[1])
      candidates.push candidate if window.Game.map[candidate.to_s()]?.walkable

    _.map candidates, (candidate) ->
      candidate.distance = target_cell.distance(candidate)

    candidates = _.sortBy(candidates, (candidate) -> candidate.distance)
    @.move_to candidates[0]

  end_of_blood: =>
    if @points_this_turn > 0
      if @to_s() of window.Game.visible_cells
        setTimeout(@go_for_blood, 100)
      else
        @go_for_blood()
    else
      window.Game.engine.unlock()
