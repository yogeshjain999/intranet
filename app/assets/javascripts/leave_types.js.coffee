# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

txtNumberOfLeaves = $ ('#leave_type_number_of_leaves')
txtNumberOfLeaves.hide()
chkAutoIncreament = $ ('#leave_type_auto_increament')
chkAutoIncreament.click ->
 
 if chkAutoIncreament.is(':checked')
   txtNumberOfLeaves.show()
 else
  txtNumberOfLeaves.hide()

