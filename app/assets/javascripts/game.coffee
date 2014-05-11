$(document).ready ->
  class Cell
    constructor: (@x, @y, @body, @color) ->
    to_s: ->
      "#{@x},#{@y}"
    move_to: (cell) ->
      @x = cell.x
      @y = cell.y
    draw: ->
      Game.display.draw(@x, @y, @body, @color)
  class Pedro extends Cell
    constructor: (cell) ->
      @body = 'P'
      @color = 'red'
      @.move_to(cell)
    act: ->
      target_cell = Game.player
      passableCallback = (x, y) ->
        "#{x},#{y}" of Game.map # check it's a walkable cell
      astar = new ROT.Path.AStar(target_cell.x, target_cell.y, passableCallback, {topology:4})

      path = []
      pathCallback = (x, y) ->
        path.push(Game.map["#{x},#{y}"])
      astar.compute(@x, @y, pathCallback)
      # this isn't checking for enemies.  only walls.

      path.shift() # remove Pedro's position
      if (path.length == 1)
        Game.engine.lock()
        alert("Game over - you were captured by Pedro!")
      else
        new_cell = path[0]
        Game.map[@.to_s()].draw()
        @.move_to(new_cell)
        @.draw()
  class Player extends Cell
    action_points: 4
    constructor: (cell) ->
      @body = '@'
      @color = '#ff0'
      @.move_to(cell)
    act: ->
      Game.engine.lock()
      @points_this_turn = @action_points
      Game.display.drawText(77, 26, String(@points_this_turn))
      window.addEventListener("keydown", this)
      window.addEventListener("keypress", this)
    checkBox: =>
      key = this.to_s()
      if (Game.map[key].body isnt "*")
        alert("There is no box here!")
      else if (key == Game.ananas) # this will just be a coordinate string..
        alert("Hooray! You found an ananas and won this game.")
        Game.engine.lock()
        window.removeEventListener("keydown", this)
      else
        alert "This box is empty :-("
    handleEvent: (e) ->
      if e.type == 'keypress'
        keyMap = {
          75: 0
          85: 1
          76: 2
          78: 3
          74: 4
          66: 5
          72: 6
          89: 7
          107: 0
          117: 1
          108: 2
          110: 3
          106: 4
          98:  5
          104: 6
          121: 7
        }

      if e.type == 'keydown'
        keyMap = {
          38: 0
          33: 1
          39: 2
          34: 3
          40: 4
          35: 5
          37: 6
          36: 7
        }

      code = e.keyCode

      if (e.type is 'keypress' and (code == 13 or code == 32))
        this.checkBox()
        return

      return if (!(code of keyMap))

      alert 'SHIFTY' if window.event.shiftKey

      diff = ROT.DIRS[8][keyMap[code]]
      new_x = this.x + diff[0]
      new_y = this.y + diff[1]

      new_cell = Game.map[new Cell(new_x, new_y).to_s()]
      return unless new_cell

      Game.map[this.to_s()].draw()
      @.move_to(new_cell)
      @.draw()
      window.removeEventListener("keydown", this)
      @points_this_turn--
      Game.display.drawText(77, 26, String(@points_this_turn))

      Game.engine.unlock() if @points_this_turn < 1

  Game = {
    display: null
    init: ->
      this.display = new ROT.Display({width: 80, height: 28})
      document.body.appendChild(this.display.getContainer())
      this._generateMap()
      scheduler = new ROT.Scheduler.Simple()
      scheduler.add(this.player, true)
      scheduler.add(this.pedro, true)
      this.engine = new ROT.Engine(scheduler)
      this.engine.start()
    drawBox: (start_x, start_y, dx, dy) ->
      for x in [start_x..(start_x+dx)]
        for y in [start_y..(start_y+dy)]
          char = ' '
          vert = (x == start_x or x == (start_x+dx))
          horiz = (y == start_y or y == (start_y+dy))
          char = '-' if horiz
          char = '|' if vert
          char = '+' if horiz and vert
          Game.display.draw(x, y, char, "#ff0")
  }

  Game.map = {}

  Game._generateMap = ->
    digger = new ROT.Map.Digger
    freeCells = []
    digCallback = (x, y, value) ->
      return if value
      new_cell = new Cell(x, y, '.', 'gray')
      this.map[new_cell.to_s()] = new_cell
      freeCells.push(new_cell)
    digger.create(digCallback.bind(this))
    this._generateBoxes(freeCells)
    this.player = this._createBeing(Player, freeCells)
    this.pedro = this._createBeing(Pedro, freeCells)
    this._drawWholeMap()
  Game._drawWholeMap = ->
    Game.drawBox(76,24,3,3)
    Game.display.drawText(77, 25, 'AC')
    for junk, cell of Game.map
      cell.draw()
      this.player.draw?()
      this.pedro.draw?()
  Game._generateBoxes = (freeCells) ->
    for i in [0..10]
      index = Math.floor(ROT.RNG.getUniform() * freeCells.length)
      replace_this_cell = freeCells.splice(index, 1)[0]
      this.map[replace_this_cell.to_s()] = new Cell(replace_this_cell.x, replace_this_cell.y, '*', 'gray')
      if (!i) then this.ananas = replace_this_cell.to_s()
  Game._createBeing = (what, freeCells) ->
    index = Math.floor(ROT.RNG.getUniform() * freeCells.length)
    return new what(freeCells[index])
  Game.init()
