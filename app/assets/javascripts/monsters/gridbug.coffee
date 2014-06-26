#= require monster

class window.Gridbug extends Monster
  constructor: (cell) ->
    super(cell.x, cell.y, 'X', 'white', 11)
    @light_attack_power = 1
    @heavy_attach_power = 8
    @action_points = 4
    @name = 'gridbug'
  topology: 4
  go_for_blood: =>
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
      @.step_toward(window.Game.player)
      @points_this_turn -= 1

    window.Game.draw_whole_map()

    if @points_this_turn > 0
      @end_of_blood()
    else
      window.Game.engine.unlock()
