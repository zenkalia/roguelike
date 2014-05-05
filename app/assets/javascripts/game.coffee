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
  drawBox(2,2,7,7,'black', 'gray')

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
