# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
play = ->
  $("#play").click ->
    jqxhr = $.getJSON("/play", (response) ->
      Rasplay.messageCenter.info("Playing")
    ).fail(->
      Rasplay.messageCenter.error("Something went wrong and we could not play the song.")
    )

pause = ->
  $("#pause").click ->
    jqxhr = $.getJSON("/pause", (response) ->
      Rasplay.messageCenter.info("Song Paused")
    ).fail(->
      Rasplay.messageCenter.error("Something went wrong and we could not pause the song.")
    )

next = ->
  $("#next").click ->
    jqxhr = $.getJSON("/next", (response) ->
      Rasplay.messageCenter.info("Playing Next Song")
    ).fail(->
      Rasplay.messageCenter.error("Something went wrong and we could not stop the song.")
    )

get_current_song = ->
  if $("#current-song").length > 0
    $.ajax
      url: "/current_song"
      dataType: "json"
      success: (data) ->
        if data != null
          $("#current-song").html(html)
          $("#band-name").html(data.band)
          $("#song-name").html(data.name)
          $("#song-url").attr("href", data.mp3_path)
          $("#song-info").attr("href", '/songs/' + data.id)
          $("#album-cover").attr("src", data.album_cover)
        else
          html = "<div class='row'>"
          html += "<h4>Current Song</h4>"
          html += "Not playing any song :("
          html += "</div>"
          $("#current-song").html(html)
      error: (data) ->

get_music_queue = ->
  if $("#music-queue").length > 0
    $.ajax
      url: "/songs_in_queue",
      dataType: "json",
      success: (data) ->
        if data != null
          if data.length > 0
            $.each data, (key, val) ->
              html = "<div class='row'>"
              html += "<table class='table'>"
              html += "<tr>"
              html += "<td class='span2'><img id='album-cover' src='" + val.album_cover +  "' height='100' width='100'></td>"
              html += "<td class='span9'>"
              html += "<strong><div id='band-name'>" + val.band + "</div></strong>"
              html += "<ul class='song_info'>"
              html += "<li id='song-name'>" + val.name + "</li>"
              html += "<li><a id='song-url' href='" + val.mp3_path + "' download><i class='icon-download'></i> Download</a></i>"
              html += "<li><a href='/songs/" + val.id + "' class='btn btn-small btn-info' id='song-info' data-id='" + val.id + "'>Song Info</a></li>"
              html += "</ul>"
              html += "</tr>"
              html += "</table>"
              html += "</div>"
              $("#music-queue").append(html)
          else
            html = "<div class='row'>"
            html += "No songs in queue :("
            html += "</div>"
            $("#music-queue").html(html)

$(document).ready get_current_song
$(document).ready get_music_queue
$(document).ready play
$(document).ready pause
$(document).ready next

$(document).on "page:load", get_current_song
$(document).on "page:load", get_music_queue
$(document).on "page:load", play 
$(document).on "page:load", pause 
$(document).on "page:load", next 

