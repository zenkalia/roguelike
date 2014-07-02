#= require cell

class window.LivingThing extends Cell
  constructor: (@x, @y, @body, @hp) ->
    @max_hp = @hp
    @light_attack_power = 1
    @heavy_attack_power = 4
    @aggro = false
  color: ->
    centz = @hp / @max_hp
    if centz > .7
      @__color = '#e0ffff'
    else if centz > .3
      @__color = '#fffacd'
    else
      @__color = '#cd5c5c'
    super
  draw: =>
    @aggro = true
    super()
  move_to: (cell) ->
    monster = window.Game.monsters[@to_s()]
    delete window.Game.monsters[@to_s()] if monster? and monster == @
    super(cell)
    window.Game.monsters[@to_s()] = @ if monster? and monster == @
  to_hit: ->
    @hp / (2 * @max_hp) + .5
  hit: (target) ->
    return 0 if ROT.RNG.getUniform() > @to_hit()
    damage = _.max [1, Math.round ROT.RNG.getNormal(@light_attack_power, @light_attack_power / 5)]
    target.hp -= damage
    damage
  heavy_hit: (target) ->
    return 0 if ROT.RNG.getUniform() > @to_hit()
    damage = _.max [1, Math.round ROT.RNG.getNormal(@heavy_attack_power, @heavy_attack_power / 5)]
    target.hp -= damage
    damage
  dead: ->
    @hp <= 0
