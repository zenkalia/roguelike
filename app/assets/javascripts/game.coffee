#= require pedro
#= require player

$(document).ready ->
  window.Game = {
    display: null
    init: ->
      @display = new ROT.Display({width: 80, height: 28})
      document.body.appendChild(@display.getContainer())
      @_generateMap()
      scheduler = new ROT.Scheduler.Simple()
      scheduler.add(@player, true)
      scheduler.add(@pedro, true)
      @engine = new ROT.Engine(scheduler)
      @engine.start()
    drawBox: (start_x, start_y, dx, dy) ->
      for x in [start_x..(start_x+dx)]
        for y in [start_y..(start_y+dy)]
          char = ' '
          vert = (x == start_x or x == (start_x+dx))
          horiz = (y == start_y or y == (start_y+dy))
          char = '-' if horiz
          char = '|' if vert
          char = '+' if horiz and vert
          window.Game.display.draw(x, y, char, "#ff0")
    map: {}
    _generateMap: ->
      digger = new ROT.Map.Digger
      freeCells = []
      digCallback = (x, y, value) ->
        return if value
        new_cell = new Cell(x, y, '.', 'gray')
        @map[new_cell.to_s()] = new_cell
        freeCells.push(new_cell)
      digger.create(digCallback.bind(@))
      @_generateBoxes(freeCells)
      @player = @_createBeing(Player, freeCells)
      @pedro = @_createBeing(Pedro, freeCells)
      @_drawWholeMap()
    _drawWholeMap: ->
      window.Game.drawBox(76,24,3,3)
      window.Game.display.drawText(77, 25, 'AC')
      for junk, cell of window.Game.map
        cell.draw()
        @player.draw?()
        @pedro.draw?()
    _generateBoxes: (freeCells) ->
      for i in [0..10]
        index = Math.floor(ROT.RNG.getUniform() * freeCells.length)
        replace_this_cell = freeCells.splice(index, 1)[0]
        @map[replace_this_cell.to_s()] = new Cell(replace_this_cell.x, replace_this_cell.y, '*', 'gray')
        if (!i) then @ananas = replace_this_cell.to_s()
    _createBeing: (what, freeCells) ->
      index = Math.floor(ROT.RNG.getUniform() * freeCells.length)
      return new what(freeCells[index])
  }
  Game.init()
