volume = ->
  setTimeout (->
    source = new EventSource("/volume_live")
    source.addEventListener "refresh", (e) ->
      data = $.parseJSON(e.data)
      console.log data.volume
      $("#volume-value").text data.volume
      $("#volume").slider( "value", data.volume );
  ), 1

updateVolume = (value) ->
  unless isNaN(value)
    $.ajax(
      type: "POST"
      url: "/volume/" + value
      data:
        volume: value
    )

volume_control = ->
  $("#volume").slider
    range: "min"
    min: 0
    max: 100
    slide: (event, ui) ->
      $("#volume-value").text ui.value
    stop: (event,ui) ->
      updateVolume(ui.value)

  $("#volume-value").text $("#volume").slider("value")

$(document).ready volume_control
$(document).ready volume
$(document).ready updateVolume
$(document).on "page:load", volume_control
$(document).on "page:load", volume
$(document).on "page:load", updateVolume

