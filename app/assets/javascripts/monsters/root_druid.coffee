#= require monster

class window.RootDruid extends Monster
  constructor: (cell) ->
    super(cell.x, cell.y, 'R', 14)
    @name = 'root druid'
    @light_attack_power = 2.6
    @heavy_attack_power = 7.8
    @action_points = 3
  go_for_blood: =>
    if @distance(window.Game.player) < 2
      if @points_this_turn == @action_points
        damage = @heavy_hit(window.Game.player)
        if damage > 0
          window.Game.log "The #{@name} rooted you!"
          window.Game.player.rooted = true
        else
          window.Game.log "The #{@name} missed you!"
        @points_this_turn -= 4
      else
        damage = @hit(window.Game.player)
        if damage > 0
          window.Game.log "The #{@name} leek slapped you."
        else
          window.Game.log "The #{@name} missed you."
        @points_this_turn -= 1
    else
      @.step_toward(window.Game.player)
      @points_this_turn -= 1

    window.Game.draw_whole_map()
    @end_of_blood()
