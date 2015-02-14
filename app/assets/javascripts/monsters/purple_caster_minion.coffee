#= require monster

class window.PurpleCasterMinion extends Monster
  constructor: (cell) ->
    super(cell.x, cell.y, 'P', 9)
    @name = 'purple caster minion'
    @heavy_attack_power = 2.4
    @light_attack_power = 1.8
    @action_points = 3
  go_for_blood: =>
    if @distance(window.Game.player) < 3 and window.Game.visible_cells[@to_s()]
      damage = @heavy_hit(window.Game.player)
      if damage > 0
        window.Game.log "The #{@name} hit you with magic."
        window.Game.player.delayed_attackers.push @
      else
        window.Game.log "The #{@name} missed."
      @points_this_turn = 0
    else
      @.step_toward(window.Game.player)
      @points_this_turn -= 1
    window.Game.draw_whole_map()

    @end_of_blood()
  delayed_hit: ->
    damage = @hit(window.Game.player)
    if damage > 0
      window.Game.log "The #{@name} hit you with delayed damage after lag"
