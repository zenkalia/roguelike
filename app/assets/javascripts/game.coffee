$(document).ready ->
  class Player
    constructor: (@x, @y) ->
    draw: ->
      Game.display.draw(@x, @y, "@", "#ff0")
    act: ->
      Game.engine.lock()
      window.addEventListener("keydown", this)
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
      # alert code

      if (code == 13 || code == 32)
        this.checkBox()
        return

      return if (!(code of keyMap))

      diff = ROT.DIRS[8][keyMap[code]]
      newX = @x + diff[0]
      newY = @y + diff[1]

      newKey = newX + "," + newY
      # alert(newKey)
      return if (!(newKey of Game.map))

      Game.display.draw(@x, @y, Game.map["#{@x},#{@y}"])
      @x = newX
      @y = newY
      @.draw()
      window.removeEventListener("keydown", this)
      Game.engine.unlock()

  Game = {
    display: null
    init: ->
      this.display = new ROT.Display
      document.body.appendChild(this.display.getContainer())
      this._generateMap()
      scheduler = new ROT.Scheduler.Simple()
      scheduler.add(this.player, true)
      this.engine = new ROT.Engine(scheduler)
      this.engine.start()
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
    this._createPlayer(freeCells)
    this._drawWholeMap()
  Game._drawWholeMap = ->
    for key, val of this.map
      parts = key.split(",")
      x = parseInt(parts[0], '10')
      y = parseInt(parts[1], '10')
      this.display.draw(x, y, this.map[key])
      this.player.draw?()
  Game._generateBoxes = (freeCells) ->
    for i in [0..10]
      index = Math.floor(ROT.RNG.getUniform() * freeCells.length)
      key = freeCells.splice(index, 1)[0]
      this.map[key] = '*'
      if (!i) then this.ananas = key
  Game._createPlayer = (freeCells) ->
    index = Math.floor(ROT.RNG.getUniform() * freeCells.length)
    key = freeCells.splice(index, 1)[0]
    parts = key.split(",")
    x = parseInt(parts[0], 10)
    y = parseInt(parts[1], 10)
    this.player = new Player(x, y)
  Game.init()
