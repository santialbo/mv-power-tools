PT.register do ($=jQuery) ->
  name =        'infinite-scrolling'
  title =       "Scroll infinito"
  description = "Carga las siguientes páginas a medida que llegas al final de la actual."
  scopes =      [PT.scopes.thread]
  
  url = loading = pages = currentPage = moarnum = moarInterval = null

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
      link = $('<a href="' + url + '/' + page + '">' + page + '</a>')
      if page = numPages then link.addClass 'last'
      link
    paginations = [$('#scrollpages'), $('strong.paginas')]
    # remove existing pagination
    paginations[0].children().slice(1).remove()
    paginations[1].children().remove()
    _.each paginations, (pagination) ->
      if numPages <= 10
        for p in [1..numPages]
          if p == page
            pagination.append '<em>' + page + '</em>'
          else
            pagination.append pageLink(p, numPages)
      else
        # first page link
        pagination.append pageLink(1, numPages) if page >= 4
        # ...
        pagination.append '<span>...</span>' if page > 4
        # 2 pages before current
        ps = [(Math.max 1, page - 2)..(Math.min numPages, page + 2)]
        if ps[0] <= _.last ps
          for p in ps
            if p == page
              pagination.append '<em>' + page + '</em>'
            else
              pagination.append pageLink(p, numPages)
        # ...
        pagination.append '<span>...</span>' if page < numPages - 3
        # last page
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

  checkCurrentPage = () =>
    scroll = $(window).scrollTop() + $(window).height()
    for page in pages
      if page.posts.first().offset().top < scroll then current = page.page else break
    console.log
    if current != currentPage
        currentPage = current
        updatePagination url, currentPage

  configurePosts = (e) ->
    posts = e.posts
    # show +1/report on moouseover
    posts
      .mouseenter(() -> $('.post_hide', $(this)).show())
      .mouseleave(() -> $('.post_hide', $(this)).hide())
    # enables +1
    $('.masmola', posts).click () ->
      counter = $(this).parent().parent().prev().find(".mola")
      pid = $(this).attr('rel')
      $.post('/foro/post_mola.php', {
        token: $("#token").val()
        tid: $("#tid").val()
        num: pid
      })
        .then (res) ->
          if (res == '1') counter.text(parseInt(counter.text()) + 1).fadeIn()
          else if res == '-1' then alert 'Ya has votado este post'
          else if res == '-2' then alert 'No puedes votar más posts hoy'
          else if res == '-3' then alert 'Regístrate para votar posts'
          else if res == '-4' then alert 'No puedes votar este post'
        .fail () -> alert 'Se ha producido un error, inténtalo más tarde'
      false
    # click on #XX for quoting
    $('.qn', posts).click () ->
      pid = $(this).attr('rel')
      textarea = $('#cuerpo')
      $('#postform').show()
      textarea.focus()
      textarea.val(textarea.val() + '#' + pid + ' ')
      $('html, body').animate { scrollTop: $(document).height() }, 'fast'
      false

  moar = () =>
    last = _.last(pages)
    if last.page < last.numPages then return
    nposts = (last.page - 1)*30 + last.posts.length
    tid = $("#tid").val()
    token = $("#token").val()
    $.get('/foro/moar.php?token=' + token + '&tid=' + tid + '&last=' + nposts)
      .then (res) ->
        if res.moar > 0
          getThreadPageInfo(url, last.page)
            .then (info) ->
              newPosts = info.posts.slice(last.posts.length)
              appendPostsToPage newPosts
              $.merge last.posts, newPosts
              if info.numPages != last.numPages
                last.numPages = info.numPages
                updatePagination url, page

  updateMoar = () ->
    last = _.last(pages)
    if last.page < last.numPages then return
    nposts = (last.page - 1)*30 + last.posts.length
    moarnum.val nposts


  init = () ->
    url = /.*\/foro\/[^\/]+\/[^\/#]+/.exec(document.URL)[0]

  _on =  () ->
    pages = [getInfoFromDocument document]
    currentPage = parseInt $('#pagina').val()
    loading = false
    $(window).bind 'scroll', loadNextPage
    $(window).bind 'scroll', checkCurrentPage
    PT.bind 'afterAddPosts', configurePosts
    moarInterval = setInterval moar, 10000
    moarnum = $('#moarnum').detach()
    $('#moarload').parent().remove()
    
  _off = () ->
    $(window).unbind 'scroll', loadNextPage
    $(window).unbind 'scroll', checkCurrentPage
    PT.unbind 'afterAddPosts', configurePosts
    updatePagination url, pages[0].page
    _.each _.rest(pages), (page) -> page.posts.remove()
    clearInterval moarInterval
    updateMoar()
    moarnum.insertAfter $('#token')

  new Module(name, title, description, scopes, false, init, _on, _off)
