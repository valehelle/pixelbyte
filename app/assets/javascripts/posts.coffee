# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Display if already checked


# Toggle on change

$(document).on 'click', '#pm-switch', (e) ->
    $("#pm-input").toggle()

$(document).on 'click', '#reply-switch', (e) ->
    $("#reply-input").toggle()