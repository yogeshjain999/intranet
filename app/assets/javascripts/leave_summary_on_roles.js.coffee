$(document).ready ->
  $("#cmbuseremail").bind 'change', (e) ->
    $.get('/users/' + $(this).val() + '/leave_summary_on_roles')
