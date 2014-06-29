#= require monster

class window.Gridbug extends Monster
  constructor: (cell) ->
    super(cell.x, cell.y, 'X', 11)
    @light_attack_power = 1
    @heavy_attach_power = 8
    @action_points = 4
    @name = 'gridbug'
  topology: 4
  go_for_blood: =>
    if @distance(window.Game.player) < 1.1
      if @points_this_turn >= 3
        damage = @heavy_hit(window.Game.player)
        if damage > 0
          window.Game.log 'The gridbug shocked you!'
        else
          window.Game.log 'The gridbug missed you!'

        @points_this_turn -= 3
      else
        damage = @hit(window.Game.player)
        if damage > 0
          window.Game.log 'The gridbug hit you.'
        else
          window.Game.log 'The gridbug missed you.'
        @points_this_turn -= 1
    else
      @.step_toward(window.Game.player)
      @points_this_turn -= 1

    window.Game.draw_whole_map()

    @end_of_blood()
