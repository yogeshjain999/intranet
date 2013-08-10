# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#user_manager_id").parent().parent().hide()

  $("#leave_type").hide()
  drop = $("#user_roles").bind 'change', (e) ->
    if $(this).val() == "Employee"
      $("#user_manager_id").parent().parent().show() 
    else
      $("#user_manager_id").parent().parent().hide()
  $('.datepicker').datepicker({
     dateFormat: "dd/mm/yy",  
     changeMonth: true,
     changeYear: true
   })

payRole = $('#user_pay_role')
payRole .click ->
  if payRole.is(':checked')
    $("#leave_type").show()
  else
    $("#leave_type").hide()
#   alert "well" 
#else
#  alert("no could not find")
joinDate = $('#user_join_date')
joinDate.blur ->
  regex=/(\d{2})\/(\d{2})\/(\d{4})/
  m=regex.exec(joinDate.val())
  probationDate = new Date(m[3], m[2]-1, m[1])
  myVar = new Date(probationDate.setMonth probationDate.getMonth() + 6)
  newVar = myVar.toLocaleDateString()
#  alert(newVar)
  $('#user_probation_end_date').val(newVar)
