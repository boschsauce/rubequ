# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
check_mpd_connected = ->
  jqxhr = $.getJSON("/connected", (response) ->
  ).fail(->
    Rubequ.messageCenter.error("MPD Server Not Connected!")
  )

lyrics = ->
  if $("#lyrics").length > 0
    id = $("#song_id").val()
    if $("#lyrics").html() != ""
      $("#lyrics").fadeToggle "fast", ->
        text = (if $("#lyric_button").text() is "Hide Lyrics" then "Lyrics" else "Hide Lyrics")
        $("#lyric_button").text(text)
    else
      $("#lyric_button").text("Fetching Lyrics...")
      $.getJSON "/songs/" + id + "/lyrics.json", (data) ->
      jqxhr = $.getJSON("/songs/" + id + "/lyrics.json", (data) ->
        $.each data, (key, val) ->
          $("#lyrics").append(val).fadeIn()
          $("#lyric_button").text "Hide Lyrics"
      ).fail(->
          $("#lyric_button").text "Could Not Find Lyrics"
      )

queue_song = ->
  $(".add_to_queue_button").click ->
    button = $(this)
    id = button.attr("id")
    jqxhr = $.getJSON("/songs/" + id + "/add_to_queue", ->
      button.text("In Queue")
      Rubequ.messageCenter.info("Added Song to Queue")
    ).fail(->
      Rubequ.messageCenter.error("Something went wrong and we could not queue the song.")
    )

$(document).ready queue_song
$(document).ready lyrics
$(document).ready check_mpd_connected

$(document).on "page:load", lyrics
$(document).on "page:load", check_mpd_connected
$(document).on "page:load", queue_song
