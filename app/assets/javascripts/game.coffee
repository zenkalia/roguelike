$(document).ready ->
  $('#game-window').html('')
  for row in [1..24]
    for col in [1..80]
      $('#game-window').append($('<span>', {
        id: "#{row}x#{col}",
        class: 'cell'
      }).append('&nbsp;'))
    $('#game-window').append('<br />')
  $('.cell').css('background-color', 'gray')
  char = {}
  char.r = 4
  char.c = 4
  setChar(char.r, char.c, 'white', 'black', '@')
  $(document).keypress (key) ->
    switch key.which
      when 104 then char.c -= 1
      when 106 then char.r += 1
      when 107 then char.r -= 1
      when 108 then char.c += 1
    setChar(char.r, char.c, 'white', 'black', '@')

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
