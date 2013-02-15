$(document).ready ->
  $("#cmbuser").bind 'change', (e) ->
    $.get('/users/' + $(this).val() + '/assignleaves')
