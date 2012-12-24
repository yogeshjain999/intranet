# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
toggleField: (field) ->
  myTarget = document.getElementById(field)
  if myTarget.type == 'hidden'
    myTarget.style.display = 'block'
  else
    myTarget.type =='none'
    myTarget.value = ''