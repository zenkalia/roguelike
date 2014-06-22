#= require item

class window.Potion extends Item
  constructor: (cell) ->
    super(cell.x, cell.y, '!', 'green')
