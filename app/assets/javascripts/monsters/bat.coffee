#= require monster

class window.Bat extends Monster
  constructor: (cell) ->
    super(cell.x, cell.y, 'B', 6)
    @name = 'bat'
    @light_attack_power = 1.6
    @action_points = 5
  move_randomly: ->
    is_adjacent = (cell) =>
      d = @distance(cell)
      is_player = window.Game.player.to_s() == cell.to_s()
      is_monster = cell.to_s() of window.Game.monsters
      d < 1.5 and d > 0 and not is_player and not is_monster and cell?.walkable
    adjacent_cells = window.Game.free_cells.filter is_adjacent
    @.move_to(_.sample(adjacent_cells)) if _.some adjacent_cells
  go_for_blood: =>
    if @points_this_turn > 3
      @move_randomly()
      @points_this_turn -= 1
    else if @distance(window.Game.player) < 2
        damage = @hit(window.Game.player)
        if damage > 0
          window.Game.log 'The bat bit you.'
        else
          window.Game.log 'The bat misses.'
        @points_this_turn -= 1
    else
      @.step_toward(window.Game.player)
      @points_this_turn -= 1

    window.Game.draw_whole_map()

    @end_of_blood()
