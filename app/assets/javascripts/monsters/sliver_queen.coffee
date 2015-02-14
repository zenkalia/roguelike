#= require monster

class window.Sliver extends Monster
  constructor: (cell) ->
    super(cell.x, cell.y, 's', 8)
    @name = 'sliver'
    @light_attack_power = 1.6
    @action_points = 4
  go_for_blood: =>
    if @distance(window.Game.player) < 2
      damage = @hit(window.Game.player)
      if damage > 0
        window.Game.log 'The sliver hit you.'
      else
        window.Game.log 'The sliver misses.'
      @points_this_turn -= 1
    else
      @.step_toward(window.Game.player)
      @points_this_turn -= 1
    window.Game.draw_whole_map()
    @end_of_blood()

class window.SliverQueen extends Monster
  constructor: (cell) ->
    super(cell.x, cell.y, 'S', 20)
    @name = 'sliver queen'
    @action_points = 1
  go_for_blood: =>
    if @distance(window.Game.player) < 2
      damage = @hit(window.Game.player)
      if damage > 0
        window.Game.log 'The sliver queen slashed you.'
      else
        window.Game.log 'The sliver queen misses.'
      @points_this_turn -= 1
    else if _.random(0,2) > 0
      @.step_toward(window.Game.player)
      @points_this_turn -= 1
    else
      is_adjacent = (cell) =>
        d = @distance(cell)
        is_player = window.Game.player.to_s() == cell.to_s()
        is_monster = cell.to_s() of window.Game.monsters
        d < 1.5 and d > 0 and not is_player and not is_monster and cell?.walkable
      adjacent_cells = window.Game.free_cells.filter is_adjacent
      if _.any adjacent_cells
        baby = new Sliver(_.sample adjacent_cells)
        window.Game.monsters[baby.to_s()] = baby
        window.Game.scheduler.add(baby, true)
      @points_this_turn -= 1
    window.Game.draw_whole_map()
    @end_of_blood()
