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

setChar = (row, col, bgColor, fgColor, character) ->
  cell = $("##{row}x#{col}")
  cell.css('background-color', bgColor)
  cell.css('color', fgColor)
  character = "\u00a0" if character == ' '
  cell.text(character)
