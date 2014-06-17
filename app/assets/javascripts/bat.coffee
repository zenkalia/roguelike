#= require monster

class window.Bat extends Monster
  constructor: (cell) ->
    super(cell.x, cell.y, 'B', 'lightgray', 6)
    @name = 'bat'
    @light_attack_power = 2
    @action_points = 5
  move_randomly: ->
    is_adjacent = (cell) =>
      d = @distance(cell)
      is_player = window.Game.player.to_s() == cell.to_s()
      is_monster = cell.to_s() of window.Game.monsters
      d < 1.5 and d > 0 and not is_player and not is_monster
    adjacent_cells = window.Game.free_cells.filter is_adjacent
    @.move_to(_.sample(adjacent_cells)) if adjacent_cells.length > 1
  go_for_blood: =>
    if @points_this_turn > 3
      @move_randomly()
      @points_this_turn -= 1
    else if @distance(window.Game.player) < 2
        @hit(window.Game.player)
        window.Game.log 'The bat bit you.'
        @points_this_turn -= 1
    else
      @.step_toward(window.Game.player)
      @points_this_turn -= 1

    window.Game.draw_whole_map()

    if @points_this_turn > 0
      @end_of_blood()
    else
      window.Game.engine.unlock()

