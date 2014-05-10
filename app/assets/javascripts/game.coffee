$(document).ready ->
  class Pedro
    constructor: (@x, @y) ->
    draw: ->
      Game.display.draw(@x, @y, 'P', 'red')
    act: ->
      x = Game.player.x
      y = Game.player.y
      passableCallback = (x, y) ->
        "#{x},#{y}" of Game.map
      astar = new ROT.Path.AStar(x, y, passableCallback, {topology:4})

      path = []
      pathCallback = (x, y) ->
        path.push([x, y])
      astar.compute(@x, @y, pathCallback)

      path.shift() # remove Pedro's position
      if (path.length == 1)
        Game.engine.lock()
        alert("Game over - you were captured by Pedro!")
      else
        x = path[0][0]
        y = path[0][1]
        Game.display.draw(@x, @y, Game.map[@x+","+@y])
        @x = x
        @y = y
        this.draw()
  class Player
    action_points: 4
    constructor: (@x, @y) ->
    draw: ->
      Game.display.draw(@x, @y, "@", "#ff0")
    act: ->
      Game.engine.lock()
      @points_this_turn = @action_points
      window.addEventListener("keydown", this)
      window.addEventListener("keypress", this)
    checkBox: ->
      key = @x + "," + @y
      if (Game.map[key] != "*")
        alert("There is no box here!")
      else if (key == Game.ananas)
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

      if (code == 13 || code == 32)
        this.checkBox()
        return

      return if (!(code of keyMap))

      alert 'SHIFTY' if window.event.shiftKey

      diff = ROT.DIRS[8][keyMap[code]]
      newX = @x + diff[0]
      newY = @y + diff[1]

      newKey = newX + "," + newY
      return if (!(newKey of Game.map))

      Game.display.draw(@x, @y, Game.map["#{@x},#{@y}"])
      @x = newX
      @y = newY
      @.draw()
      window.removeEventListener("keydown", this)
      @points_this_turn--
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
  Game.player = null
  Game.engine = null
  Game.ananas = null


  Game._generateMap = ->
    digger = new ROT.Map.Digger
    freeCells = []
    digCallback = (x, y, value) ->
      return if value
      key = "#{x},#{y}"
      this.map[key] = '.'
      freeCells.push(key)
    digger.create(digCallback.bind(this))
    this._generateBoxes(freeCells)
    this.player = this._createBeing(Player, freeCells)
    this.pedro = this._createBeing(Pedro, freeCells)
    this._drawWholeMap()
  Game._drawWholeMap = ->
    Game.drawBox(76,24,3,3)
    for key, val of this.map
      parts = key.split(",")
      x = parseInt(parts[0], '10')
      y = parseInt(parts[1], '10')
      this.display.draw(x, y, this.map[key])
      this.player.draw?()
      this.pedro.draw?()
  Game._generateBoxes = (freeCells) ->
    for i in [0..10]
      index = Math.floor(ROT.RNG.getUniform() * freeCells.length)
      key = freeCells.splice(index, 1)[0]
      this.map[key] = '*'
      if (!i) then this.ananas = key
  Game._createBeing = (what, freeCells) ->
    index = Math.floor(ROT.RNG.getUniform() * freeCells.length)
    key = freeCells.splice(index, 1)[0]
    parts = key.split(",")
    x = parseInt(parts[0], 10)
    y = parseInt(parts[1], 10)
    return new what(x, y)
  Game.init()
