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
    target.bleed()
    damage
  heavy_hit: (target) ->
    return 0 if ROT.RNG.getUniform() > @to_hit()
    damage = _.max [1, Math.round ROT.RNG.getNormal(@heavy_attack_power, @heavy_attack_power / 5)]
    target.hp -= damage
    target.bleed()
    target.bleed()
    damage
  dead: ->
    @hp <= 0
  bleed: ->
    blood_color = ->
      r = _.sample(['8', '9', '0', 'a', 'b', 'c', 'd', 'e'])
      "#{r}#{r}0000"
    return unless _.random(0, 1) == 0
    window.Game.map[@to_s()].__color = blood_color()
    return unless _.random(0, 1) == 0
    splash = "#{@x + _.random(-1, 1)},#{@y + _.random(-1, 1)}"
    window.Game.map[splash].__color = blood_color()
