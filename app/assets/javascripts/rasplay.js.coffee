window.Rasplay = {}


$ ->
  $("#volume").slider
    range: "min"
    value: 50
    min: 0
    max: 100
    slide: (event, ui) ->
      $("#volume-value").text ui.value

  $("#volume-value").text $("#volume").slider("value")
