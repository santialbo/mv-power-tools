PT.register do ($=jQuery) ->
  name =        'extended-reply-form'
  title =       "Formulario extendido"
  description = "Nueva barra de botones en el formulario de edición."
  scopes =      [() -> PT.scopes.loggedIn() and (PT.scopes.thread() or PT.scopes.reply() or PT.scopes.compose())]

  textarea = $('textarea#cuerpo')
  oldToolbar = $('#btsmile').parent()
  toolbar =  $("""
    <div id="pt-extended-reply-form-toolbar" class="btn-toolbar" style="display: hidden;">
      <div class="btn-group">
        <button id="form-b" class="btn btn-small" original-title="Negrita" type="button"><i class="icon-bold"></i></button>
        <button id="form-i" class="btn btn-small" original-title="Cursiva" type="button"><i class="icon-italic"></i></button>
        <button id="form-u" class="btn btn-small" original-title="Subrayado" type="button"><i class="icon-underline"></i></button>
        <button id="form-s" class="btn btn-small" original-title="Tachado" type="button"><i class="icon-strikethrough"></i></button>
      </div>
      <div class="btn-group">
        <button id="form-list" class="btn btn-small" original-title="Lista" type="button"><i class="icon-list"></i></button>
        <button id="form-center" class="btn btn-small" original-title="Centrado" type="button"><i class="icon-align-center"></i></button>
      </div>
      <div class="btn-group">
        <button id="form-url" class="btn btn-small" original-title="Link" type="button"><i class="icon-link"></i></button>
        <button id="form-img" class="btn btn-small" original-title="Imagen" type="button"><i class="icon-picture"></i></button>
        <button id="form-video" class="btn btn-small" original-title="Video" type="button"><i class="icon-play"></i></button>
        <button id="form-tweet" class="btn btn-small" original-title="Tweet" type="button"><i class="icon-twitter"></i></button>
        <button id="form-audio" class="btn btn-small" original-title="Audio" type="button"><i class="icon-music"></i></button>
      </div>
      <div class="btn-group">
        <button id="form-spoiler" class="btn btn-small" original-title="Spoiler" type="button">spoiler</button>
        <button id="form-spoiler-named" class="btn btn-small" original-title="Spoiler con nombre" type="button">spoiler=</button>
        <button id="form-nsfw" class="btn btn-small" original-title="NSWF" type="button">NSFW</button>
      </div>
      <div class="btn-group">
        <button id="form-code" class="btn btn-small" original-title="Código" type="button"><i class="icon-code"></i></button>
        <button id="form-cmd" class="btn btn-small" original-title="Comando" type="button"><i class="icon-terminal"></i></button>
      </div>
      <div class="btn-group">
        <button id="form-smiley" class="btn btn-small" original-title="Smilies" type="button"><i class="icon-smile"></i></button>
      </div>
    </div>
    """)

  bbcodeSimple = (openTag, closeTag = openTag) ->
    [start, end, text] = [textarea[0].selectionStart, textarea[0].selectionEnd, textarea.val()]
    slices = [text.slice(0, start), text.slice(start, end), text.slice(end)]
    textarea.val(slices[0] + '[' + openTag + ']' + slices[1] + '[/' + closeTag + ']' + slices[2])
    textarea.focus()
    if start == end
      pos = start + 2 + openTag.length
      textarea[0].setSelectionRange pos, pos

  bbcodeNamed = (openTag, closeTag = openTag) ->
    [start, end, text] = [textarea[0].selectionStart, textarea[0].selectionEnd, textarea.val()]
    slices = [text.slice(0, start), text.slice(start, end), text.slice(end)]
    textarea.val(slices[0] + '[' + openTag + '=]' + slices[1] + '[/' + closeTag + ']' + slices[2])
    textarea.focus()
    pos = start + 2 + openTag.length
    textarea[0].setSelectionRange pos, pos
    if start == end
      textarea[0].setSelectionRange pos + 1, pos + 1

  ['b', 'i', 'u', 's', 'center', 'img', 'video', 'tweet', 'audio', 'spoiler', 'code', 'cmd']
  .map (tag) ->
    $('#form-' + tag, toolbar).click () ->
      bbcodeSimple tag; false

  $('#form-url', toolbar).click () -> bbcodeNamed 'url'; false
  $('#form-spoiler-named', toolbar).click () -> bbcodeNamed 'spoiler'; false
  $('#form-nsfw', toolbar).click () -> bbcodeSimple 'spoiler=NSFW', 'spoiler'; false

  $('#form-list').click () ->
    [start, end, text] = [textarea[0].selectionStart, textarea[0].selectionEnd, textarea.val()]
    slices = [text.slice(0, start), text.slice(start, end).replace(/^/gm, '* '), text.slice(end)]
    textarea.val(slices[0] + '[list]' + slices[1] + '[/list]' + slices[2])
    textarea.focus()
    if start == end
      pos = start + 8
      textarea[0].setSelectionRange(pos, pos)
    false

  $('#form-smiley', toolbar).click () ->
    b = textarea.parent().width() - 10
    c = b - 120
    smilies = $('#smilies')
    if smilies.is(':hidden')
      textarea.animate {width: c + "px"}, 200, () -> smilies.fadeIn 'slow'
    else
      smilies.fadeOut(200, () -> textarea.animate {width: b + "px"}, 200)

  init = () ->
    toolbar.insertBefore oldToolbar

  _on =  () ->
    oldToolbar.hide()
    toolbar.show()

  _off = () ->
    oldToolbar.show()
    toolbar.hide()

  new Module(name, title, description, scopes, false, init, _on, _off)
