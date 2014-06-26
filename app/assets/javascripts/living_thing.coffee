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
    damage = _.max [1, Math.round ROT.RNG.getNormal(@light_attack_power, @light_attack_power / 5)]
    console.log damage
    target.hp -= damage
  heavy_hit: (target) ->
    damage = _.max [1, Math.round ROT.RNG.getNormal(@heavy_attack_power, @heavy_attack_power / 5)]
    console.log damage
    target.hp -= damage
  dead: ->
    @hp <= 0
