PT.register do ($=jQuery) ->
  name =        'media-embeed'
  title =       "Incrusta imágenes y videos"
  description = "Abre los links a imágenes como si fueran spoilers."
  scopes =      [PT.scopes.thread]

  imageDivWithSrc = (src) ->
    """
    <div class="pt-media-embeed pt-media-embeed-image">
      <img src="#{src}" onload="imgLimit(this)" />
    </div>
    """

  youtubeDivWithId = (id) ->
    """
    <div class="pt-media-embeed pt-media-embeed-youtube embedded">
      <iframe width="560" height="349" frameborder="0" allowfullscreen=""
        src="http://www.youtube.com/embed/#{id}?rel=0&hd=1&wmode=opaque"
        type="text/html" title="YouTube video player">
      </iframe>
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
    },{ # Youtube video #https://www.youtube.com/watch?v=oLkm3ecMD7g
      matcher: /youtube.com\/watch\?v=[a-zA-Z0-9]+(&.*)?$/,
      transformer: (href) -> youtubeDivWithId href.match(/youtube.com\/watch\?v=([a-zA-Z0-9]+)(&.*)?$/)[1]
    }
  ]

  embeedMedia = (posts) ->
    buttonHtml = '<a class="pt-media-embeed pt-media-embeed-button"></a>'
    posts.find('.body').find('a[href]')
      .filter(() -> _.any(medias, ((media) -> media.matcher.test $(this).attr('href')), this))
      .filter(() -> $(this).find('img').length == 0)
      .each (i, link) ->
        $(buttonHtml).insertAfter(link).click () ->
          $(this).toggleClass('less')
          img = $(this).next('div.pt-media-embeed-image')
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
    $('.pt-media-embeed').remove()
    PT.unbind 'afterAddPosts', embeedMediaEvent

  new Module(name, title, description, scopes, false, init, _on, _off)
