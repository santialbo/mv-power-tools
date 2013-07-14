PT.register do ($=jQuery) ->
  name =        'infinite-scrolling'
  title =       "Scroll infinito"
  description = "Carga las siguientes páginas a medida que llegas al final de la actual."
  scopes =      [PT.scopes.thread]
  
  url = loading = pages = currentPage = null

  getInfoFromDocument = (doc) ->
    page = parseInt $('#pagina', doc).val()
    last = $('a.last', doc)
    return {} =
      page: page
      numPages: if last.length then parseInt(last.first().text()) else page
      posts: $('.post:not(.postit,:last)', doc)

  getThreadPageInfo = (url, page) ->
    $.get(url + '/' + page).then (source) ->
      getInfoFromDocument new DOMParser().parseFromString(source, 'text/html')

  appendPostsToPage = (posts) ->
    $('#aultimo').remove()
    bottompanel = $('#bottompanel')
    posts.each (i, post) ->
      if i == posts.length - 1
        $('<a id="aultimo" name="ultimo"></a>').insertBefore bottompanel
      num = $(post).attr('id').replace 'post', ''
      $('<a name="' + num + '"></a>').insertBefore bottompanel
      $(post).insertBefore bottompanel
    PT.raise 'afterAddPosts', {posts: posts}

  updatePagination = (url, page) ->
    numPages = _.last(pages).numPages
    pageLink = (page, numPages=page) ->
      link = $('<a href="' + url + '/' + p + '">' + p + '</a>')
      if page = numPages then link.addClass 'last'
      link
    paginations = [$('#scrollpages'), $('strong.paginas')]
    # remove existing pagination
    paginations[0].children().slice(1).remove()
    paginations[1].children().remove()
    _.each paginations, (pagination) ->
      pagination.append pageLink(1, numPages) if page >= 4
      pagination.append '<span>...</span>' if page > 4
      pagination.append pageLink(p, numPages) for p in [(Math.max 1, page - 2)..(page - 1)]
      pagination.append '<em>' + page + '</em>'
      pagination.append pageLink(p, numPages) for p in [(page + 1)..(Math.min numPages, page + 2)]
      pagination.append '<span>...</span>' if page < numPages - 3
      pagination.append pageLink(numPages).addClass 'last' if page <= numPages - 3

  loadNextPage = () =>
    if loading then return
    scroll = $(window).scrollTop() + $(window).height()
    bpScroll = $('#bottompanel').offset().top
    last = _.last(pages)
    if scroll > bpScroll and not $('#postform').is(':visible') and last.page < last.numPages
      loading = true
      sign = $('<div id="pt-infinite-scrolling-sign" class="alert alert-info"></div>')
        .html('<strong>Cargando respuestas</strong> ...')
        .insertBefore $('#bottompanel')
      getThreadPageInfo(url, currentPage + 1)
        .then (info) ->
          pages.push info
          appendPostsToPage info.posts
          sign.remove()
          loading = false
        .fail () ->
          sign.html('<strong>Error cargando respuestas.</strong> <a href="' + url + '/' + currentPage +'#aultimo">Recarga la página</a>').removeClass('alert-info')

  init = () ->
    loading = false
    url = /.*\/foro\/[^\/]+\/[^\/#]+/.exec(document.URL)[0]
    pages = [getInfoFromDocument document]
    currentPage = parseInt $('#pagina').val()

  _on =  () ->
    $(window).bind 'scroll', loadNextPage
    
  _off = () ->
    $(window).unbind 'scroll', loadNextPage

  new Module(name, title, description, scopes, false, init, _on, _off)
