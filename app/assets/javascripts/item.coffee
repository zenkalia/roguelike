#= require cell

class window.Item extends Cell
  to_inventory: ->
    "#{@inventory_id} - #{@name}"
