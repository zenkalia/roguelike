#= require monster

class window.Zebra extends Monster
  constructor: (cell) ->
    super(cell.x, cell.y, 'Z', 15)
    @name = 'zebra'
    @light_attack_power = 3.6
    @action_points = 1
  go_for_blood: =>
    if @distance(window.Game.player) >= 2
      @.hop_toward(window.Game.player)
    if @distance(window.Game.player) < 2
      damage = @hit(window.Game.player)
      if damage > 0
        window.Game.log 'The zebra bites you.'
      else
        window.Game.log 'The zebra misses.'
    @points_this_turn -= 1
    window.Game.draw_whole_map()
    @end_of_blood()
