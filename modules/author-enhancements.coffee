PT.register do ($=jQuery) ->
  name =        'author-enhancements'
  title =       "Información de usuario"
  description = "Muestra accesos directos varios y botón de información debajo del avatar."
  scopes =      [PT.scopes.thread]

  getUserInfo = (id) ->
    url = 'http://www.mediavida.com/id/' + id
    $.get(url).then (source) ->
      doc = source
      div = $('div.userinfo', doc)
      info = {}
      [person, status, registration, forum] = _.pluck div.children(), 'textContent'
      [info.name, info.age, info.city] = /\ *(.*),(?:\n +\t+(-?\d+) años, +(.*))?/.exec(person).slice(1)
      info.lastSeen = /((?:online)|(?:\d+ [^ ]+))/.exec(status)[0]
      info.registered = /(\d+ [^ ]+ \d+)/.exec(registration)[1]
      [info.posts, info.visits, info.firmas] = /(\d+) posts \| (\d+) visitas \| (\d+) firmas/.exec(forum).slice(1)
      info

  enhanceAuthor = (posts) ->
    $('dd.online', posts).hide()
    posts.find('.autor').each (i, divAuthor) ->
      if $(divAuthor).find('a:first').length == 0 then return
      id = $(divAuthor).find('a:first').attr('href').match(/\/id\/(.*)/)[1]
      enhancements = $("""
        <dd class="pt-author-enhancements">
          <a class="pt-author-status" href="">
            <i class="icon-user"></i>
          </a>
          <a class="pt-author-mensaje" href="/mensajes/nuevo/#{id}" original-title="Mensaje">
            <i class="icon-envelope-alt"></i>
          </a>
          <a class="pt-author-firma" href="/id/#{id}/firmas" original-title="Firmas">
            <i class="icon-comments-alt"></i>
          </a>
          <a class="pt-author-info" original-title="Info" href="#">
            <i class="icon-info-sign"></i>
          </a>
        </dd>
        """).insertAfter $($(this).children().first().children()[2])

      online = $(divAuthor).find('dd.online').length > 0
      $('.pt-author-status > i', enhancements)
        .css('color', if online then 'green' else 'rgb(128,0,0)')
        .attr('original-title', if online then 'Online' else 'Offline')

      $('a.pt-author-info', enhancements).click () ->
        divInfo = $('.pt-author-userinfo', $(divAuthor))
        if divInfo.length > 0
          divInfo.slideToggle()
        else
          getUserInfo(id).then (info) ->
            thousands = (num) ->
              num.replace /\B(?=(\d{3})+(?!\d))/g, '.'
            userinfo = $('<dd class="pt-author-userinfo"></dd>')
            name = $('<dd><strong>' + info.name + '</strong></dd>')
            if info.age
              userinfo.append(name.append $('<span> (' + info.age + ')</span>'))
            if info.city
              $('<dd>en ' + info.city + '</dd>').appendTo userinfo
            if info.lastSeen != 'online'
              $('<dd>visto hace ' + info.lastSeen + '</dd>').appendTo userinfo
            userinfo.append $("""
              <dd>registro: #{info.registered}</dd>
              <dd>posts: #{thousands(info.posts)}</dd>
              <dd>visitas: #{thousands(info.visits)}</dd>
              <dd><a href=\"/id/#{id}/firmas\">firmas: #{thousands(info.firmas)}</a></dd>
            """)
            userinfo.insertAfter($(enhancements)).slideToggle()

        $("div.tipsy").remove()
        false

      $('a', enhancements).tipsy()
  
  enhanceAuthorEvent = (e) -> enhanceAuthor e.posts

  init = () ->

  _on =  () ->
    enhanceAuthor $('.post:not(.postit,:last)')
    PT.bind 'afterAddPosts', enhanceAuthorEvent

  _off = () ->
    $('dd.online').show()
    $('.pt-author-enhancements').remove()
    $('.pt-author-userinfo').remove()
    PT.unbind 'afterAddPosts', enhanceAuthorEvent

  new Module(name, title, description, scopes, false, init, _on, _off)
