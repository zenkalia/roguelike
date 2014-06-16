#= require cell

class window.LivingThing extends Cell
  constructor: (@x, @y, @body, @color, @hp) ->
    @max_hp = @hp
    @light_attack_power = 1
    @heavy_attack_power = 4
    @aggro = false
  draw: =>
    @aggro = true
    super()
  move_to: (cell) ->
    monster = window.Game.monsters[@to_s()]
    delete window.Game.monsters[@to_s()] if monster? and monster == @
    super(cell)
    window.Game.monsters[@to_s()] = @ if monster? and monster == @
  hit: (target) ->
    target.hp -= @light_attack_power
  heavy_hit: (target) ->
    target.hp -= @heavy_attack_power
  dead: ->
    @hp <= 0
  end_of_blood: =>
    if @points_this_turn > 0
      if @to_s() of window.Game.visible_cells
        setTimeout(@go_for_blood, 100)
      else
        @go_for_blood()
