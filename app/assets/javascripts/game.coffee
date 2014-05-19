#= require pedro
#= require player

$(document).ready ->
  window.Game = {
    display: null
    init: ->
      @display = new ROT.Display({width: 80, height: 28})
      $('#game-window').append(@display.getContainer())
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
    log: (msg) ->
      $('#console-log').append("\n> #{msg}")
      $('#console-log').scrollTop($('#console-log')[0].scrollHeight)
    map: {}
    monsters: {}
    _generateMap: ->
      digger = new ROT.Map.Digger
      free_cells = []
      digCallback = (x, y, value) ->
        return if value
        new_cell = new Cell(x, y, '.', 'gray')
        @map[new_cell.to_s()] = new_cell
        free_cells.push(new_cell)
      digger.create(digCallback.bind(@))
      @_generateBoxes(free_cells)
      @player = new Player(_.sample(free_cells))
      @pedro = @_createMonster(Pedro, free_cells)
      @draw_whole_map()
    draw_whole_map: ->
      for key, monster of window.Game.monsters
        delete window.Game.monsters[key] if monster.dead()
      window.Game.display.clear()
      window.Game.drawBox(76,24,3,3)
      window.Game.display.drawText(77, 26, String(@player.points_this_turn))
      window.Game.display.drawText(77, 25, 'AC')
      window.Game.display.drawText(50, 25, "HP: #{@player.hp}/#{@player.max_hp}")
      light_passes = (x, y) ->
        not not window.Game.map[new Cell(x, y).to_s()]
      fov = new ROT.FOV.PreciseShadowcasting(light_passes)
      fov_callback = (x, y, r, visibility) ->
        light = light_passes(x, y)
        key = "#{x},#{y}"
        if light
          window.Game.draw(key)
        else
          window.Game.display.draw(x, y, '#', 'gray')
      fov.compute(@player.x, @player.y, 10, fov_callback)
      window.Game.player.draw()
    draw: (key) ->
      monster = window.Game.monsters[key]
      return monster.draw() if monster?
      window.Game.map[key].draw()
    _generateBoxes: (free_cells) ->
      for i in [0..10]
        free_cell = _.sample(free_cells)
        free_cell.body = '*'
        @ananas = free_cell.to_s() unless i
    _createMonster: (what, free_cells) ->
      new_thing = new what(_.sample(free_cells))
      @monsters[new_thing.to_s()] = new_thing
  }
  Game.init()
