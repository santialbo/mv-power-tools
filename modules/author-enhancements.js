(function($, PT) {
    $(function() {
        var enhanceAuthor = function(posts) {
            posts.find('.autor').each(function() {
                var authorId = $(this).find('a:first').attr('href').match(/\/id\/(.*)/)[1];
                var online = $(this).find('dd.online').length > 0;
                $(this).find('dd.online').remove();
                var enhancements = $([
                    '<div class="powertools">',
                        '<div class="online-pos">',
                            '<a class="tooltip pt-' + (online ? 'online' : 'offline') + ' sprite icon" href="/id/' + authorId + '" title="Perfil"></a>',
                        '</div>',
                        '<div class="mensaje-pos">',
                            '<a class="tooltip pt-mensaje sprite icon" href="/mensajes/nuevos/' + authorId + '" title="Mensaje"></a>',
                        '</div>',
                        '<div class="firma-pos">',
                            '<a class="tooltip pt-firmas sprite icon" href="/id/' + authorId + '/firmas" title="Firmas"></a>',
                        '</div>',
                    '</div>'].join(''));
                $(this).append(enhancements);
            });
        } 

        var css = [
            '.sprite {',
                'background: url(' + PT.resURL + '/ext/img/sprites18-3.png) no-repeat;',
            '}',
            '.icon {',
                'text-indent: -9999px;',
                'display: block;',
                'outline: 0;',
                'margin-top: 1px;',
            '}',
            '.pt-firmas {',
                'background-position: 0 -58px;',
                'width: 14px;',
                'height: 11px;',
            '}',
            '.pt-firmas:hover {',
                'background-position: 0 -69px;',
            '}',
            '.pt-mensaje {',
                'background-position: -20px -58px;',
                'width: 14px;',
                'height: 10px;',
            '}',
            '.pt-mensaje:hover {',
                'background-position: -20px -68px;',
            '}',
            '.pt-online {',
                'background-position: -56px -72px;',
                'width: 8px;',
                'height: 12px;',
            '}',
            '.pt-offline {',
                'background-position: -56px -58px;',
                'width: 8px;',
                'height: 12px;',
            '}',
            '.online-pos {',
                'float: left;',
                'width: 14px;',
                'height: 12px;',
                'z-index: 999;',
            '}',
            '.mensaje-pos {',
                'float: left;',
                'width: 19px;',
                'height: 12px;',
                'padding-top: 1px;',
            '}',
            '.firma-pos {',
                'float: left;',
                'width: 19px;',
                'height: 12px;',
                'padding-top: 1px;',
            '}',
        ].join('');
        $('head').append('<style type="text/css">' + css + '</style>');

        enhanceAuthor($('.post:not(.postit,:last)'));

        document.addEventListener('afterAddPosts', function(e) {
            enhanceAuthor(e.detail);
        });
    });
})(jQuery, window.PowerTools);
