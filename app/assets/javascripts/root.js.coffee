# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
play = ->
  $("#play").click ->
    jqxhr = $.getJSON("/play", (response) ->
      get_current_song()
      get_music_queue(true)
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
      console.log "next clicked"
      get_current_song()
      get_music_queue(true)
      Rasplay.messageCenter.info("Playing Next Song")
    ).fail(->
      Rasplay.messageCenter.error("Something went wrong and we could not stop the song.")
    )

refresh = ->
  $("#refresh").click ->
    get_current_song()
    get_music_queue(true)
    Rasplay.messageCenter.info("Refreshed")

reload = ->
  setInterval (->
    get_current_song()
    get_music_queue(false)
  ), 5000


get_current_song = ->
  if $("#current-song").length > 0
    $.ajax
      url: "/current_song"
      dataType: "json"
      success: (data) ->
        if data != null
          html = ""
          html += "<h4><i class='icon-music'></i>Current Song</h4>"
          html += "<div class='row'>"
          html += "<table class='table'>"
          html += "<tr>"
          html += "<td class='span2'><img id='album-cover' src='" + data.album_cover + "' height='100' width='100'></td>"
          html += "<td class='span9'>"
          html += "<strong><div id='band-name'>" + data.band  + "</div></strong>"
          html += "<ul class='song_info'>"
          html += "<li id='song-name'>" + data.name + "</li>"
          html += "<li><a id='song-url' href='" + data.mp3_path + "' download><i class='icon-download'></i> Download</a></li>"
          html += "<li><a href='/songs/" + data.id + "' data-action='viewsong' class='btn btn-small btn-info' id='song-info'>Song Info</a></li>"
          html += "</ul>"
          html += "</td>"
          html += "</tr>"
          html += "</table>"
          html += "</div>"
          $("#current-song").html(html)
          $("#current-song").parent().show()
        else
          html = "<h4><i class='icon-music'></i>Current Song</h4>"
          html += "<hr>"
          html += "<div class='row'>"
          html += "<h5>No Song Currently Playing</h5>"
          html += "</div>"
          $("#current-song").html(html)
          $("#current-song").parent().show()
      error: (data) ->

get_music_queue = (show_spinner) ->
  if $("#music-queue").length > 0
    if show_spinner is true
      opts =
        lines: 13 # The number of lines to draw
        length: 20 # The length of each line
        width: 10 # The line thickness
        radius: 30 # The radius of the inner circle
        corners: 1 # Corner roundness (0..1)
        rotate: 0 # The rotation offset
        direction: 1 # 1: clockwise, -1: counterclockwise
        color: "#000" # #rgb or #rrggbb
        speed: 1 # Rounds per second
        trail: 60 # Afterglow percentage
        shadow: false # Whether to render a shadow
        hwaccel: false # Whether to use hardware acceleration
        className: "spinner" # The CSS class to assign to the spinner
        zIndex: 2e9 # The z-index (defaults to 2000000000)
        top: "auto" # Top position relative to parent in px
        left: "auto" # Left position relative to parent in px

      target = document.getElementById("music-queue")
      spinner = new Spinner(opts).spin(target);

    $.ajax
      url: "/songs_in_queue",
      dataType: "json",
      success: (data) ->
        if data != null
          if data.length > 0
            $("#music-queue").html("<h4>Music Queue</h4>")
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
            html =  "<h4>Music Queue</h4>"
            html += "<hr>"
            html += "<div class='row'>"
            html += "<h5>No Songs in the Queue</h5>"
            html += "</div>"
            $("#music-queue").html(html)

          $("#music-queue").parent().show()
          if show_spinner is true
            spinner.stop()

$(document).ready get_current_song
$(document).ready get_music_queue
$(document).ready play
$(document).ready pause
$(document).ready next
$(document).ready refresh
$(document).ready reload

$(document).on "page:load", get_current_song
$(document).on "page:load", get_music_queue
$(document).on "page:load", play
$(document).on "page:load", pause
$(document).on "page:load", next
$(document).on "page:load", refresh


