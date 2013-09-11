getVolume = ->
  jqxhr = $.getJSON("/volume", (val) ->
    $("#volume-value").text val
    $("#volume").slider( "value", val );
  ).fail(->
    $("#volume-value").text 0
    $("#volume").slider( "value", 0 );
  )

jQuery(document).ready ->
  setTimeout (->
    source = new EventSource("/volume_live")
    source.addEventListener "refresh", (e) ->
      console.log "in here"
      console.log e.data
      #window.location.reload()

  ), 1



updateVolume = (value) ->
  if value
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
  getVolume

reloadVolume = ->
  setInterval (->
    getVolume()
  ), 5000

  #$(document).ready volume_control
  #$(document).ready getVolume
  #$(document).ready reloadVolume
$(document).ready update_volume_live

#$(document).on "page:load", volume_control
#$(document).on "page:load", getVolume

