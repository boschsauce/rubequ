class Rubequ.MessageCenter
  constructor: ->
    @showDelay = 4 #seconds

  error: (message, delay) =>
    @_show("error", message, delay)

  info: (message, delay) =>
    @_show("info", message, delay)

  alert: (message) ->
    modal = $("#alert-modal")
    modal.find(".message").html(message)
    modal.modal()

  _show: (type, message, delay = @showDelay) =>
    if message
      $messageCenter = $("#message-center")
      $messageCenter.html($("<div>").addClass("alert alert-#{type}").html(message))

      $messageCenter.css(marginLeft: -$messageCenter.outerWidth() / 2) for i in [1..3]

      $messageCenter.slideDown("fast")
      _.delay(@_hide, delay * 1000)

  _hide: =>
    $("#message-center").slideUp("fast")

Rubequ.messageCenter = new Rubequ.MessageCenter()

$ ->
  Rubequ.messageCenter.info(window.initialInfoMessage)
  Rubequ.messageCenter.error(window.initialErrorMessage)

