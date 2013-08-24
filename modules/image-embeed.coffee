PT.register do ($=jQuery) ->
  name =        'image-embeed'
  title =       "Incrusta imágenes"
  description = "Abre los links a imágenes como si fueran spoilers, sin necesidad de cambiar de página."
  scopes =      [PT.scopes.thread]

  imageDivWithSrc = (src) ->
    """
    <div class="pt-image-embeed pt-image-embeed-image">
      <img src="#{src}" onload="imgLimit(this)" />
    </div>
    """
  
  # medias is an array of objects with a matcher function that matches the url of the link
  # and a transformer function that takes the link and transforms it to the dom element that
  # will be shown.
  medias = [
    {   # Raw images
      matcher: /\.(jpe?g|gif|png)(\?.*)?$/,
      transformer: (href) -> imageDivWithSrc href
    },{ # Imgur images
      matcher: /imgur.com\/[a-zA-Z0-9]+(\?.*)?$/,
      transformer: (href) -> imageDivWithSrc "http://i.imgur.com/#{href.match(/imgur.com\/([a-zA-Z0-9]+)/)[1]}.jpg"
    }
  ]

  embeedMedia = (posts) ->
    buttonHtml = '<a class="pt-image-embeed pt-image-embeed-button"></a>'
    posts.find('.body').find('a[href]')
      .filter(() -> _.any(medias, ((media) -> media.matcher.test $(this).attr('href')), this))
      .filter(() -> $(this).find('img').length == 0)
      .each (i, link) ->
        $(buttonHtml).insertAfter(link).click () ->
          $(this).toggleClass('less')
          img = $(this).next('div.pt-image-embeed-image')
          if img.length > 0
            img.toggle()
          else
            media = _.find medias, ((media) ->
              href = $(link).attr('href')
              media.matcher.test(href) and $(media.transformer(href)).insertAfter($(this))
            ), this
          false

  embeedMediaEvent = (e) ->
    embeedMedia e.posts

  init = () ->

  _on =  () ->
    embeedMedia $('.post:not(.postit,:last)')
    PT.bind 'afterAddPosts', embeedMediaEvent

  _off = () ->
    $('.pt-image-embeed').remove()
    PT.unbind 'afterAddPosts', embeedMediaEvent

  new Module(name, title, description, scopes, false, init, _on, _off)
