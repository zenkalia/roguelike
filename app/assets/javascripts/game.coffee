$(document).ready ->
  $('#game-window').html('')
  for row in [1..20]
    for col in [1..80]
      $('#game-window').append($('<span>', {
        id: "#{row}x#{col}",
        class: 'cell'
      }).append('&nbsp;'))
    $('#game-window').append('<br />')
  $('.cell').css('background-color', 'gray')
