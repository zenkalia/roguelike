#= require monster

class window.Knobgoblin extends Monster
  constructor: (cell) ->
    super(cell.x, cell.y, 'K', 'pink', 20)
    @light_attack_power = 1
    @heavy_attack_power = 15
    @action_points = 2
    @name = 'knobgoblin'
  go_for_blood: =>
    if @distance(window.Game.player) < 2
      if @points_this_turn >= 2
        @heavy_hit(window.Game.player)
        window.Game.log "The #{@name} smashed you!"
        @points_this_turn -= 2
      else
        @hit(window.Game.player)
        window.Game.log "The #{@name} hit you."
        @points_this_turn -= 1
    else
      @.step_toward(window.Game.player)
      @points_this_turn -= 1

    window.Game.draw_whole_map()

    if @points_this_turn > 0
      @end_of_blood()
    else
      window.Game.engine.unlock()
