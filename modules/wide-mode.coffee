PT.register do ($=jQuery) ->
  name =        'wide-mode'
  title =       "Modo ancho"
  description = "Elimina la columna de la derecha en posts y ensancha la principal."
  scopes =      [PT.scopes.thread]

  widenPosts = (posts) ->
    $(posts).find('.msg .body .cuerpo').css({width: '800px'})
    $(posts).find('.msg').css({width: '800px'})
    $(posts).find('.binfo .bwrap').css({width: '800px'})

  narrowPosts = (posts) ->
    $(posts).find('.msg .body .cuerpo').css({width: '620px'})
    $(posts).find('.msg').css({width: '620px'})
    $(posts).find('.binfo .bwrap').css({width: '620px'})

  widenPostsEvent = (e) -> widenPosts e.posts

  init = () ->

  _on = () ->
    $('.largecol').css {width: '960px'}
    $('.tinycol').animate {width: 'toggle'}
    widenPosts $('.largecol .post')
    PT.bind 'afterAddPosts', widenPostsEvent

  _off = () ->
    $('.largecol').css {width: '780px'}
    $('.tinycol').animate {width: 'toggle'}
    narrowPosts $('.largecol .post')
    PT.unbind 'afterAddPosts', widenPostsEvent

  new Module(name, title, description, scopes, false, init, _on, _off)
