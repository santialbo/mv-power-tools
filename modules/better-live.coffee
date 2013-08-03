PT.register do ($=jQuery) ->
  name =        'better-live'
  title =       "Mejoras en hilos live"
  description = "Pequeñas mejoras en hilos live."
  scopes =      [PT.scopes.threadLive]

  enableQuoting = () ->
    textarea = $('#cuerpo')
    $('#postform').show()
    textarea.focus()
    textarea.val(textarea.val() + $(this).html() + ' ')
    $('html, body').animate { scrollTop: $('#postform').offset().top }, 'fast'
    false

  enableQuotingOnEvent = () ->
    $('.info a').unbind 'click', enableQuoting
    $('.info a').bind 'click', enableQuoting

  init = () ->

  _on = () ->
    $('.info a').bind 'click', enableQuoting
    $('#liveposts').bind 'DOMNodeInserted', enableQuotingOnEvent

  _off = () ->
    $('.info a').unbind 'click', enableQuoting
    $('#liveposts').unbind 'DOMNodeInserted', enableQuotingOnEvent

  new Module(name, title, description, scopes, false, init, _on, _off)
