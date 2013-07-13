PT.register do ($=jQuery) ->
  name =        'author-enhancements'
  title =       "Información de usuario"
  description = "Muestra accesos directos varios debajo del avatar."
  scopes =      [PT.scopes.thread]

  getUserInfo = (id) ->
    url = 'http://www.mediavida.com/id/' + id
    $.get(url).then (source) ->
      doc = new DOMParser().parseFromString source, "text/html"
      div = $('div.userinfo', doc)
      info = {}
      [person, status, registration, forum] = _.pluck div.children(), 'textContent'
      [info.name, info.city, info.age] = /\ *(.*),(?:\n +\t+(-?\d+) años, +(.*))?/.exec(person).slice(1)
      info.lastSeen = /((?:online)|(?:\d+ [^ ]+))/.exec(status)[0]
      info.registered = /(\d+ [^ ]+ \d+)/.exec(registration)[1]
      [info.post, info.visits, info.firmas] = /(\d+) posts \| (\d+) visitas \| (\d+) firmas/.exec(forum).slice(1)

  enhanceAuthor = (posts) ->
    posts.find('.autor').each () ->
      if $(this).find('a:first').length == 0 then return
      id = $(this).find('a:first').attr('href').match(/\/id\/(.*)/)[1]
      enhancements = $("""
        <dd class="pt-author-enhancements">
          <a class="pt-author-status" href="javascript:;" original-title="Offline">
            <i class="icon-user"></i>
          </a>
          <a class="pt-author-mensaje" href="/mensajes/nuevos/""" + id + """" original-title="Mensaje">
            <i class="icon-envelope-alt"></i>
          </a>
          <a class="pt-author-firma" href="/id/""" + id + """/firmas" original-title="Firmas">
            <i class="icon-comments-alt"></i>
          </a>
          <a class="pt-author-info" original-title="Info" href="#" rel=""" + '"' + id + """">
            <i class="icon-info-sign"></i>
          </a>
        </dd>
        """).insertAfter $($(this).children().first().children()[2])

      if $(this).find('dd.online').length > 0
        $('.pt-author-status', enhancements)
          .addClass('pt-author-online')
          .attr('original-title', 'Online')

      $('a', enhancements).tipsy()


  init = () ->

  _on =  () ->
    $('dd.online').hide()
    enhanceAuthor $('.post:not(.postit,:last)')

  _off = () ->
    $('dd.online').show()
    $('.pt-author-enhancements').remove()

  new Module(name, title, description, scopes, false, init, _on, _off)
