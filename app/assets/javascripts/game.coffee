#= require gridbug
#= require bat
#= require player

$(document).ready ->
  window.Game = {
    y_offset:
      4
    display: null
    init: ->
      @display = new ROT.Display({width: 80, height: 28})
      $('#game-window').append(@display.getContainer())
      @scheduler = new ROT.Scheduler.Simple()
      @_generateMap()
      @scheduler.add(@player, true)
      @engine = new ROT.Engine(@scheduler)
      @engine.start()
    drawBar: (start_x, y, end_x, color, percent) ->
      window.Game.display.draw(start_x, y, '<', 'gray')
      window.Game.display.draw(end_x, y, '>', 'gray')
      left = start_x + 1
      right = end_x - 1
      for x in [left..right]
        window.Game.display.draw(x, y, '=', if ((x - left) / (right - left) < percent) then color else 'gray')
    log: (msg) ->
      _.each "#{msg}".split("\n"), (m, index) =>
        c = if index == 0 then '>' else ' '
        $('#console-log').append("\n#{c} #{m}")
      $('#console-log').scrollTop($('#console-log')[0].scrollHeight)
    map: {}
    monsters: {}
    free_cells: []
    visible_cells: {}
    _generateMap: ->
      digger = new ROT.Map.Digger(80, 24, dugPercentage: .7)
      @free_cells = []
      digCallback = (x, y, value) =>
        return if value
        new_cell = new Cell(x, y, '.', 'gray')
        @map[new_cell.to_s()] = new_cell
        @free_cells.push(new_cell)
      digger.create digCallback
      @_generateBoxes()
      @player = new Player(_.sample(@free_cells))
      @_createMonster(Gridbug)
      @_createMonster(Gridbug)
      @_createMonster(Bat)
      @_createMonster(Bat)
      @_createMonster(Bat)
      @_createMonster(Bat)
      @_createMonster(Knobgoblin)
      @_createMonster(Knobgoblin)
      @draw_whole_map()
    combat_mode: ->
      for key, monster of window.Game.monsters
        return true if monster.aggro
      false
    tick: ->
      for key, monster of window.Game.monsters
        if monster.dead()
          @scheduler.remove monster
          delete window.Game.monsters[key]
    draw_whole_map: ->
      @tick()
      window.Game.display.clear()
      window.Game.display.drawText(0, 0, "HP: #{@player.hp}/#{@player.max_hp}")
      window.Game.drawBar(12,0,79,'yellow', @player.hp / @player.max_hp)
      window.Game.display.drawText(0, 1, "AP: #{@player.points_this_turn}/#{@player.action_points}")
      window.Game.drawBar(12,1,79,'blue', @player.points_this_turn / @player.action_points)
      light_passes = (x, y) ->
        not not window.Game.map[new Cell(x, y).to_s()]
      @visible_cells = {}
      fov = new ROT.FOV.PreciseShadowcasting(light_passes)
      fov_callback = (x, y, r, visibility) =>
        light = light_passes(x, y)
        if light
          key = "#{x},#{y}"
          window.Game.draw(key)
          @visible_cells[key] = window.Game.map[key]
        else
          window.Game.display.draw(x, y + @y_offset, '#', 'gray')
      fov.compute(@player.x, @player.y, 120, fov_callback)
      window.Game.player.draw()
    draw: (key) ->
      monster = window.Game.monsters[key]
      return monster.draw() if monster?
      window.Game.map[key].draw()
    _generateBoxes: ->
      for i in [0..10]
        free_cell = _.sample(@free_cells)
        free_cell.body = '*'
        @ananas = free_cell.to_s() unless i
    _createMonster: (what) ->
      new_thing = new what(_.sample(@free_cells))
      @monsters[new_thing.to_s()] = new_thing
      @scheduler.add(new_thing, true)
  }
  Game.init()
