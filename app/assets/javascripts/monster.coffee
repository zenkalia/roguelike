#= require living_thing

class window.Monster extends LivingThing
  act: ->
    return unless @aggro
    window.Game.engine.lock()
    @points_this_turn = @action_points
    @go_for_blood()
