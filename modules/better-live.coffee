PT.register do ($=jQuery) ->
  name =        'better-live'
  title =       "Mejoras en hilos live"
  description = "Pequeñas mejoras en hilos live."
  scopes =      [PT.scopes.threadLive]

  plusOne = """
    <div class="post_controls">
      <ul style="display: none;" class="buttons post_hide" id="menupost1">
        <li>
          <a original-title="Me gusta" href="#" class="button masmola btip">
            <img src="/style/img/botones/thumb_up.png" alt="me gusta" height="14" width="14">
          </a>
        </li>
      </ul>
	</div>
    """

  addPlusOne = () ->
    console.log $(plusOne)
    $('#liveposts .post')
      .filter(() -> $(this).find('.post_controls').length == 0)
      .prepend(plusOne)
      .mouseenter(() -> $('.post_hide', $(this)).show())
      .mouseleave(() -> $('.post_hide', $(this)).hide())
      .find('a.masmola').click () ->
        post = $(this).parent().parent().parent().parent()
        pid = post.find('.info a').eq(0).text().replace('#', '')
        $.post('/foro/post_mola.php', {
          token: $("#token").val()
          tid: $("#tid").val()
          num: pid
        }).then (res) ->
          switch res
            when '-1' then alert 'Ya has votado este post'
            when '-2' then alert 'No puedes votar más posts hoy'
            when '-3' then alert 'Regístrate para votar posts'
            when '-4' then alert 'No puedes votar este post'
        .fail () -> alert 'Se ha producido un error, inténtalo más tarde'
        false

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
    addPlusOne()
    $('#liveposts').bind 'DOMNodeInserted', addPlusOne

  _off = () ->
    $('.info a').unbind 'click', enableQuoting
    $('#liveposts').unbind 'DOMNodeInserted', enableQuotingOnEvent
    $('#liveposts').unbind 'DOMNodeInserted', addPlusOne
    $('.post_controls').remove()

  new Module(name, title, description, scopes, false, init, _on, _off)
