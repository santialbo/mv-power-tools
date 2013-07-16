PT.register do ($=jQuery) ->
  name =        'live-preview'
  title =       "Vista previa automática"
  description = "Muestra al momento una vista previa del mensaje que estés escribiendo."
  scopes =      [() -> PT.scopes.loggedIn() and (PT.scopes.thread() or PT.scopes.reply() or PT.scopes.compose())]

  textarea = $('textarea#cuerpo')
  
  livePreview = $("""
      <div id="pt-live-preview-outer" display="hidden">
        <div id="pt-live-preview-middle">
          <div id="pt-live-preview-inner"></div>
        </div>
      </div> 
      """)

  updatePreview = () ->
    cabecera = $('#cabecera')
    post = $.merge($('#postear'), $('#postform')).serialize()
    console.log post
    $.post("/foro/acciones_preview.php", post).then (res) ->
      $('#pt-live-preview-inner').html(JSON.parse(res).cuerpo)

  throttledUpdatePreview = _.throttle updatePreview, 2000
  timedUpdatePreview = () -> setTimeout updatePreview, 100

  init = () ->
    livePreview.insertBefore textarea.parent().children().first()

  _on =  () ->
    livePreview.show()
    textarea.bind 'input propertychange', throttledUpdatePreview
    $('#pt-extended-reply-form-toolbar').find('button').bind 'click', timedUpdatePreview
    $('#btsmile').parent().find('button').bind 'click', timedUpdatePreview
    $('#smilies').find('a').bind 'click', timedUpdatePreview

  _off = () ->
    livePreview.hide()
    textarea.unbind 'input propertychange', throttledUpdatePreview
    $('#pt-extended-reply-form-toolbar').find('button').unbind 'click', timedUpdatePreview
    $('#btsmile').parent().find('button').unbind 'click', timedUpdatePreview
    $('#smilies').find('a').unbind 'click', timedUpdatePreview

  new Module(name, title, description, scopes, false, init, _on, _off)
