PT.register do ($=jQuery) ->
  name =        'image-embeed'
  title =       "Incrusta imágenes"
  description = "Abre los links a imágenes sin necesidad de cambiar de página."
  scopes =      [PT.scopes.thread]

  embeedImages = (posts) ->
    buttonHtml = '<a class="pt-image-embeed pt-image-embeed-button"></a>'
    posts.find('.body').find('a[href]')
      .filter(() -> /\.(jpe?g|gif|png)$/.test($(this).attr 'href'))
      .filter(() -> $(this).find('img').length == 0)
      .each (i, link) ->
        $(buttonHtml).insertAfter(link).click () ->
          $(this).toggleClass('less')
          img = $(this).next('div.pt-image-embeed-image')
          if img.length > 0
            img.toggle()
          else
            $("""
              <div class="pt-image-embeed pt-image-embeed-image">
                <img src="#{$(link).attr('href')}" onload="imgLimit(this)" />
              </div>
              """).insertAfter($(this))
          false

  embeedImagesEvent = (e) -> embeedImages e.posts

  init = () ->

  _on =  () ->
    embeedImages $('.post:not(.postit,:last)')
    PT.bind 'afterAddPosts', embeedImagesEvent

  _off = () ->
    $('.pt-image-embeed').remove()
    PT.unbind 'afterAddPosts', embeedImagesEvent

  new Module(name, title, description, scopes, false, init, _on, _off)
