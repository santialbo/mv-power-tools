(function($, PowerTools, Mousetrap) {
    $(function() {
        var BASE_URL = 'http://www.mediavida.com';
        var FAVS_URL = '/foro/favoritos';
        var PROFILE_URL = '/id/';
        var NOTIF_URL = '/notificaciones';
        var PM_URL = '/mensajes';
        var FORUM_URL = '/foro/';
        var SPY_URL = '/foro/spy';
        
        var bind = function(url, shortcut) {
            Mousetrap.bind(shortcut, function() {
                window.location.href = url;
            });
        };

        var shortcuts = {
            'p': BASE_URL + PROFILE_URL + PowerTools['user'],
            'a': BASE_URL + NOTIF_URL,
            'n': BASE_URL + NOTIF_URL,
            'f': BASE_URL + FAVS_URL,
            'm': BASE_URL + PM_URL,
            's': BASE_URL + SPY_URL,
            'g a': BASE_URL + FORUM_URL + 'anime-manga',
            'g c': BASE_URL + FORUM_URL + 'cine',
            'g d': BASE_URL + FORUM_URL + 'deportes',
            'g e': BASE_URL + FORUM_URL + 'electronica-gadgets',
            'g f': BASE_URL + FORUM_URL + 'feda',
            'g g': BASE_URL + FORUM_URL + 'moviles-tablets',
            'g h': BASE_URL + FORUM_URL + 'hard-soft',
            'g j': BASE_URL + FORUM_URL + 'juegos',
            'g l': BASE_URL + FORUM_URL + 'libros',
            'g m': BASE_URL + FORUM_URL + 'motor',
            'g o': BASE_URL + FORUM_URL + 'off-topic',
            'g t': BASE_URL + FORUM_URL + 'tv',
            'g v': BASE_URL + FORUM_URL + 'videos',
            'g w': BASE_URL + FORUM_URL + 'dev',
            'g z': BASE_URL + FORUM_URL + 'mediavida',
        };
        _.each(shortcuts, bind);

        var tid = $('#tid');
        var fid = $('#fid');
        if (tid.length > 0) {
            Mousetrap.bind('r', function() {
                $('#postform').show();
                $('#cuerpo').focus();
                $("html, body").animate({ scrollTop: $(document).height() }, "fast");
            });
        } else if (fid.length > 0) {
            bind(BASE_URL + FORUM_URL + 'post.php?fid=' + fid[0].value, 'c');
        }
    });
})(jQuery, window.PowerTools, Mousetrap);
