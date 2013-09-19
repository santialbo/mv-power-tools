PT.register do ($=jQuery) ->
  name =        'media-embed'
  title =       "Incrusta imágenes y videos"
  description = "Abre los links a imágenes como si fueran spoilers."
  scopes =      [PT.scopes.thread]

  imageDivWithSrc = (src) ->
    """
    <div class="pt-media-embed pt-media-embed-embedded">
      <img src="#{src}" onload="imgLimit(this)" />
    </div>
    """

  youtubeDivWithId = (id) ->
    """
    <div class="pt-media-embed pt-media-embed-embedded embedded">
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
      matcher: /youtube.com\/watch\?v=[a-zA-Z0-9_]+(&.*)?$/,
      transformer: (href) -> youtubeDivWithId href.match(/youtube.com\/watch\?v=([a-zA-Z0-9_]+)(&.*)?$/)[1]
    }
  ]

  embedMedia = (posts) ->
    buttonHtml = '<a class="pt-media-embed pt-media-embed-button"></a>'
    posts.find('.body').find('a[href]')
      .filter(() -> _.any(medias, ((media) -> media.matcher.test $(this).attr('href')), this))
      .filter(() -> $(this).find('img').length == 0)
      .each (i, link) ->
        $(buttonHtml).insertAfter(link).click () ->
          $(this).toggleClass('less')
          img = $(this).next('.pt-media-embed-embedded')
          if img.length > 0
            img.toggle()
          else
            media = _.find medias, ((media) ->
              href = $(link).attr('href')
              media.matcher.test(href) and $(media.transformer(href)).insertAfter($(this))
            ), this
          false

  embedMediaEvent = (e) ->
    embedMedia e.posts

  init = () ->

  _on =  () ->
    embedMedia $('.post:not(.postit,:last)')
    PT.bind 'afterAddPosts', embedMediaEvent

  _off = () ->
    $('.pt-media-embed').remove()
    PT.unbind 'afterAddPosts', embedMediaEvent

  new Module(name, title, description, scopes, false, init, _on, _off)
