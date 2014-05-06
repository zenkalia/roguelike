$(document).ready ->
  Game = {
    display: null
    init: ->
      this.display = new ROT.Display
      document.body.appendChild(this.display.getContainer())
      this._generateMap()
  }
  Game.map = {}
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
    this._drawWholeMap()
  Game._drawWholeMap = ->
    for key, val of this.map
      parts = key.split(",")
      x = parseInt(parts[0], '10')
      y = parseInt(parts[1], '10')
      this.display.draw(x, y, this.map[key])
  Game._generateBoxes = (freeCells) ->
    for i in [0..10]
      index = Math.floor(ROT.RNG.getUniform() * freeCells.length)
      key = freeCells.splice(index, 1)[0]
      this.map[key] = '*'
  Game.init()








#$(document).ready ->
  #$('#game-window').html('')
  #for row in [1..24]
    #for col in [1..80]
      #$('#game-window').append($('<span>', {
        #id: "#{row}x#{col}",
        #class: 'cell'
      #}).append('&nbsp;'))
    #$('#game-window').append('<br />')
  #$('.cell').css('background-color', 'gray')
  #window.char = {}
  #char.r = 4
  #char.c = 4
  #window.enemies = []
  #enemies.push {
    #r: 7
    #c: 7
  #}
  #draw()
  #$(document).keypress (key) ->
    #switch key.which
      #when 104 then char.c -= 1
      #when 106 then char.r += 1
      #when 107 then char.r -= 1
      #when 108 then char.c += 1
    #draw()

draw = ->
  setChar(char.r, char.c, 'white', 'black', '@')
  for enemy in enemies
    setChar(enemy.r, enemy.c, 'yellow', 'green', 'R')

setChar = (row, col, bgColor, fgColor, character) ->
  cell = $("##{row}x#{col}")
  cell.css('background-color', bgColor)
  cell.css('color', fgColor)
  character = "\u00a0" if character == ' '
  cell.text(character)

drawBox = (row, col, endRow, endCol, bgColor, fgColor) ->
  for r in [row..endRow]
    for c in [col..endCol]
      cell = $("##{r}x#{c}")
      horiz = (r == row || r == endRow)
      vert = (c == col || c == endCol)
      char = ' '
      if horiz && vert
        char = '+'
      else if horiz
        char = '-'
      else if vert
        char = '|'
      setChar(r, c, bgColor, fgColor, char)
