#= require item

class window.Potion extends Item
  constructor: (cell) ->
    super(cell.x, cell.y, '!', '#00ff00')
    @name = 'green potion'
    @inventory_id = null
