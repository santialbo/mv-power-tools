PT.register do ($=jQuery, Mousetrap) ->
  name =        'shortcuts'
  title =       "Atajos de teclado"
  description = "Atajos de teclado para navegar por mediavida a la velocidad del viento."
  scopes =      [PT.scopes.all]

  URL = 'http://www.mediavida.com'

  actions =
    'Perfil': () ->
      if PT.scopes.loggedIn()
        window.location.href = URL + '/id/' + $('a.lu').eq(0).text()
      else
        window.location.href = URL + '/login.php?return=' + document.URL.replace URL, ''
    'Favoritos': () -> window.location.href = URL + '/foro/favoritos'
    'Avisos': () -> window.location.href = URL + '/notificaciones'
    'Mensajes': () -> window.location.href = URL + '/mensajes'
    'Foros': () -> window.location.href = URL + '/foro/'
    'Spy': () -> window.location.href = URL + '/foro/spy'
    'Nuevo tema': () ->
      if PT.scopes.forum() then window.location.href = URL + '/foro/post.php?fid=' + $('#fid').val()
    'Responder': () ->
      if PT.scopes.thread() or PT.scopes.threadLive()
        $('#postform').show()
        $('#cuerpo').focus()
        $("html, body").animate { scrollTop: $('#postform').offset().top }, 'fast'
    'Foro - Acusaciones de cheats': () -> window.location.href = URL + '/foro/cheats'
    'Foro - Anime y manga': () -> window.location.href = URL + '/foro/anime-manga'
    'Foro - Aplicaciones móvil': () -> window.location.href = URL + '/foro/aplicaciones-movil'
    'Foro - Arena: Servidores públicos de MV': () -> window.location.href = URL + '/foro/arena'
    'Foro - Battlefield': () -> window.location.href = URL + '/foro/battlefield'
    'Foro - Bloodline Champions': () -> window.location.href = URL + '/foro/blc'
    'Foro - Call of Duty': () -> window.location.href = URL + '/foro/call-of-duty'
    'Foro - Cine': () -> window.location.href = URL + '/foro/cine'
    'Foro - Cocina': () -> window.location.href = URL + '/foro/cocina'
    'Foro - Compra-Venta': () -> window.location.href = URL + '/foro/compra-venta'
    'Foro - Comunidad': () -> window.location.href = URL + '/foro/juegos-comunidad'
    'Foro - Counter-Strike': () -> window.location.href = URL + '/foro/counterstrike'
    'Foro - Day of Defeat': () -> window.location.href = URL + '/foro/dod'
    'Foro - Deportes': () -> window.location.href = URL + '/foro/deportes'
    'Foro - Desarrollo y diseño': () -> window.location.href = URL + '/foro/dev'
    'Foro - Diablo': () -> window.location.href = URL + '/foro/diablo'
    'Foro - Dota': () -> window.location.href = URL + '/foro/dota'
    'Foro - El club de la hucha': () -> window.location.href = URL + '/foro/club-hucha'
    'Foro - Electrónica y gadgets': () -> window.location.href = URL + '/foro/electronica-gadgets'
    'Foro - Estudios y trabajo': () -> window.location.href = URL + '/foro/estudios-trabajo'
    'Foro - FEDA': () -> window.location.href = URL + '/foro/feda'
    'Foro - Fitness': () -> window.location.href = URL + '/foro/fitness'
    'Foro - Guild Wars 2': () -> window.location.href = URL + '/foro/gw2'
    'Foro - Hardware y software': () -> window.location.href = URL + '/foro/hard-soft'
    'Foro - Heroes of Newerth': () -> window.location.href = URL + '/foro/hon'
    'Foro - Juegos de mesa y rol': () -> window.location.href = URL + '/foro/juegos-mesa-rol'
    'Foro - Juegos móvil': () -> window.location.href = URL + '/foro/juegos-movil'
    'Foro - Juegos': () -> window.location.href = URL + '/foro/juegos'
    'Foro - League of Legends': () -> window.location.href = URL + '/foro/lol'
    'Foro - Libros y cómics': () -> window.location.href = URL + '/foro/libros-comics'
    'Foro - MMO': () -> window.location.href = URL + '/foro/mmo'
    'Foro - Mascotas': () -> window.location.href = URL + '/foro/mascotas'
    'Foro - Mediavida': () -> window.location.href = URL + '/foro/mediavida'
    'Foro - Minecraft': () -> window.location.href = URL + '/foro/minecraft'
    'Foro - Motor': () -> window.location.href = URL + '/foro/motor'
    'Foro - Móviles y tablets': () -> window.location.href = URL + '/foro/moviles-tablets'
    'Foro - Música': () -> window.location.href = URL + '/foro/musica'
    'Foro - Noticias de deportes': () -> window.location.href = URL + '/foro/noticias-deportes'
    'Foro - OFF-Topic': () -> window.location.href = URL + '/foro/off-topic'
    'Foro - Path of Exile': () -> window.location.href = URL + '/foro/pathofexile'
    'Foro - Poker': () -> window.location.href = URL + '/foro/poker'
    'Foro - Pokémon': () -> window.location.href = URL + '/foro/pokemon'
    'Foro - SalsaLoL': () -> window.location.href = URL + '/foro/salsalol'
    'Foro - Shopping': () -> window.location.href = URL + '/foro/shopping'
    'Foro - Star Wars: The Old Republic': () -> window.location.href = URL + '/foro/swtor'
    'Foro - StarCraft': () -> window.location.href = URL + '/foro/starcraft'
    'Foro - Televisión': () -> window.location.href = URL + '/foro/tv'
    'Foro - The Fallout Scrolls: New Skyrim': () -> window.location.href = URL + '/foro/bethesda'
    'Foro - Viajes': () -> window.location.href = URL + '/foro/viajes'
    'Foro - Vídeos': () -> window.location.href = URL + '/foro/videos'
    'Foro - World of Warcraft': () -> window.location.href = URL + '/foro/wow'

  defaults =
    'p': 'Perfil'
    'f': 'Favoritos'
    'a': 'Avisos'
    'n': 'Avisos'
    'm': 'Mensajes'
    's': 'Spy'
    'c': 'Nuevo tema'
    'r': 'Responder'
    'g a': 'Foro - Anime y manga'
    'g c': 'Foro - Cine'
    'g d': 'Foro - Deportes'
    'g e': 'Foro - Electrónica y gadgets'
    'g f': 'Foro - FEDA'
    'g g': 'Foro - Móviles y tablets'
    'g h': 'Foro - Hardware y software'
    'g j': 'Foro - Juegos'
    'g l': 'Foro - Libros y cómics'
    'g m': 'Foro - Motor'
    'g o': 'Foro - OFF-Topic'
    'g r': 'Foro - MMO',
    'g t': 'Foro - Televisión'
    'g v': 'Foro - Vídeos'
    'g w': 'Foro - Desarrollo y diseño'
    'g z': 'Foro - Mediavida'

  init = () ->
    #This will be used when shortcuts are fully customizable
    #if not PT.options.exists 'shortcuts' then PT.options.set 'shortcuts', defaults
    PT.options.set 'shortcuts', defaults

  _on =  () ->
    shortcuts = PT.options.get 'shortcuts'
    _.each shortcuts, (action, shortcut) =>
      Mousetrap.bind shortcut, actions[action]

  _off = () ->
    shortcuts = PT.options.get 'shortcuts'
    _.each shortcuts, (action, shortcut) ->
      Mousetrap.unbind shortcut

  new Module(name, title, description, scopes, false, init, _on, _off)
