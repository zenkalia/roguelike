#= require monster

class window.Angel extends Monster
  constructor: (cell) ->
    super(cell.x, cell.y, 'A', 14)
    @name = 'angel'
    @light_attack_power = 3.3
    @action_points = 5
  go_for_blood: =>
    if @points_this_turn > 4 and window.Game.visible_cells[@to_s()]
      window.Game.log 'YOU DUN GOT BLINDED'
      window.Game.player.blinded = true
      @points_this_turn -= 4
    else if @distance(window.Game.player) < 2
      damage = @hit(window.Game.player)
      if damage > 0
        window.Game.log 'The angel slashed you.'
      else
        window.Game.log 'The angel missed.'
      @points_this_turn -= 1
    else
      @.step_toward(window.Game.player)
      @points_this_turn -= 1
    window.Game.draw_whole_map()

    @end_of_blood()
