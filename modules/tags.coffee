PT.register do ($=jQuery) ->
  name =        'tags'
  title =       "Tags"
  description = "Añade tags a los usuarios de mediavida."
  scopes =      [PT.scopes.thread]

  tags = null
  defaultColor = '#609be8'
  lastPostClicked = null

  enhanceAuthor = (post) ->
    user = $(post).find('.autor > dl > dt > a').html()
    $(post).find('.pt-tags').remove()
    if user of tags and $.trim(tags[user].tag) != ""
      addTag post, user
    else
      if $(post).find('.pt-tags-button').show().length == 0
        addTagIcon post

  addTag = (post, user) ->
    tagElem = $("""
      <div class="pt-tags">
        <span class="pt-tags-tag">
          <a href="#"><i class="icon-remove"></i></a> 
          <span>#{ $.trim(tags[user].tag) }</span>
        </span>
      </div>
    """)
    tagElem.appendTo $(post).find('.autor')
    tagElem.find('.pt-tags-tag').css 'background-color', tags[user].color
    tagElem.find('.pt-tags-tag span').click () ->
      showTagForm post
    tagElem.find('a').click ->
      delete tags[user]
      PT.options.set 'tags', tags
      enhanceAuthor(post)
      false
      

  addTagIcon = (post) ->
    $("""
      <a class="pt-tags-button" href="#" original-title="Añadir Tag">
        <i class="icon-tag"></i>
      <a>
    """).tipsy()
      .click(() ->
        showTagForm post
        $('.tipsy').remove()
        false
      ).appendTo('<dl></dl>').appendTo $(post).find('.autor dl')

  showTagForm = (post) ->
    _.defer () ->
      $(post).find('.pt-tags-button').hide()
      $(post).find('.pt-tags').remove()
    # allow only one form at a time
    if lastPostClicked then formCancel lastPostClicked
    lastPostClicked = post

    user = $(post).find('.autor > dl > dt > a').html()
    if user of tags
      tag = tags[user].tag
      color = tags[user].color
    else
      color = defaultColor
      tag = ""
      
    form = $("""
      <div class="pt-tags-form">
        <div class="pt-tags-row">
          <span class="pt-tags-field">Tag</span>
          <input class="pt-tags-tag-name" type="text"" value="#{ tag }"></input>
        </div>
        <div class="pt-tags-row">
          <span class="pt-tags-field">Color</span>
          <input class="pt-tags-tag-color minicolors" type="text" value="#{ color }"></input>
        </div>
        <div class="pt-tags-row">
          <span class="btn btn-mini pt-tags-cancel">Cerrar</span>
          <span class="pull-right btn btn-primary btn-mini pt-tags-save">Guardar</span>
        </div>
      </div>
    """)
    form.appendTo $(post).find('.autor')
    form.find('.pt-tags-tag-name').focus().val(tag)
    form.find('.pt-tags-tag-color').minicolors({control: 'wheel'})
    form.find('.pt-tags-cancel').click () -> formCancel post
    form.find('.pt-tags-save').click () -> formSave post, user
    form.slideToggle()

  formSave = (post) ->
    user = $(post).find('.autor > dl > dt > a').html()
    tag = $.trim($(post).find('.pt-tags-tag-name').val())
    color = $(post).find('.pt-tags-tag-color').val()
    if tag == ""
      delete tags[user]
    else
      tags[user] = {tag: tag, color: color}
    PT.options.set 'tags', tags
    formCancel post

  formCancel = (post) ->
    $(post).find('.pt-tags-form').remove()
    enhanceAuthor post

  enhanceAuthorEvent = (e) ->
    $(e.posts).each((i, post) -> enhanceAuthor post)

  init = () ->
    tags = PT.options.get('tags') ? {}

  _on = () ->
    PT.bind 'afterAddPosts', enhanceAuthorEvent
    $('.post:not(.postit,:last)').each((i, post) -> enhanceAuthor post)
    $('.autor').addClass 'pt-tags-autor'

  _off = () ->
    PT.unbind 'afterAddPosts', enhanceAuthorEvent
    $('.pt-tags').remove()
    $('.pt-tags-button').remove()
    $('.pt-tags-form').remove()
    $('.autor').removeClass 'pt-tags-autor'

  new Module(name, title, description, scopes, false, init, _on, _off)
