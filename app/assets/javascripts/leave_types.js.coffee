# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$('#leave_type_number_of_leaves').parent().parent().hide()
chkAutoIncreament = $ ('#leave_type_auto_increament')
chkAutoIncreament.click ->
 
 if chkAutoIncreament.is(':checked')
   $('#leave_type_number_of_leaves').parent().parent().show()
 else
  $('#leave_type_number_of_leaves').parent().parent().hide()

