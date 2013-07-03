(function($, PT) {
    $(function() {
        // author-enhancements only works in threads
        if ($('#tid').length == 0 || /\/foro\/post.php/.exec(document.URL)) return;

        var getUserInfo = function(userId) {
            var url = PT.url + '/id/' + userId;
            return $.get(url).then(function(source) {
                var div = $('div.userinfo', source);
                return {
                    personalInfo: / *(.*),(?:\n +\t+(-?\d+) años, +(.*))?/.exec(div.children()[0].textContent).slice(1),
                    lastSeen: /((?:online)|(?:visto hace \d+ [^ ]+))/.exec(div.children()[1].textContent)[0].replace('visto hace ', ''),
                    registered: /miembro desde +(\d+ [^ ]+ \d+)/.exec(div.children()[2].textContent)[1],
                    forumInfo: /(\d+) posts \| (\d+) visitas \| (\d+) firmas/.exec(div.children()[3].textContent).slice(1).map(function(n) { return parseInt(n); }),
                };
            });
        };

        var enhanceAuthor = function(posts) {
            posts.find('.autor').each(function() {
                if ($(this).find('a:first').length == 0) return;
                var authorId = $(this).find('a:first').attr('href').match(/\/id\/(.*)/)[1];
                var online = $(this).find('dd.online').length > 0;
                $(this).find('dd.online').remove();
                var enhancements = $([
                    '<div class="pt-author-enhancements">',
                        '<div class="online-pos">',
                            '<a class="tooltip pt-' + (online ? 'online' : 'offline') + ' sprite icon" href="/id/' + authorId + '" original-title="Perfil"></a>',
                        '</div>',
                        '<div class="mensaje-pos">',
                            '<a class="tooltip pt-mensaje sprite icon" href="/mensajes/nuevos/' + authorId + '" original-title="Mensaje"></a>',
                        '</div>',
                        '<div class="firma-pos">',
                            '<a class="tooltip pt-firmas sprite icon" href="/id/' + authorId + '/firmas" original-title="Firmas"></a>',
                        '</div>',
                        '<div class="info-pos">',
                            '<a class="tooltip pt-info" original-title="Info" href="#" rel="' + authorId + '"><strong>+</strong></a>',
                        '</div>',
                    '</div>'].join(''));
                $(this).append(enhancements);
                $('.tooltip', enhancements).tipsy();
            });
            $('a.pt-info', posts).click(function() {
                var userId = $(this).attr('rel');
                var authorDiv = $(this).parent().parent().parent();
                getUserInfo(userId).then(function(info) {
                    authorDiv.append([
                        '<dl class="pt-userinfo">',
                            '<dd><strong>' + info.personalInfo[0] + '</strong>' + (info.personalInfo[1] ? ' (' + info.personalInfo[1] + ')' : '') + '</dd>',
                            (info.personalInfo[2] ? '<dd>de ' + info.personalInfo[2] + '</dd>' : ''),
                            '<dd>' + (info.lastSeen == 'online' ? '' : 'visto hace ') + info.lastSeen + '</dd>',
                            '<dd>registro: ' + info.registered + '</dd>',
                            '<dd>posts: ' + info.forumInfo[0].toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.') + '</dd>',
                            '<dd>visitas: ' + info.forumInfo[1].toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.') + '</dd>',
                            '<dd><a href="/id/' + userId + '/firmas">firmas: ' + info.forumInfo[2].toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.') + '</a></dd>',
                        '</dl>',
                        ].join(''));
                });
                $(this).contents().unwrap();
                $("div.tipsy").remove();
                return false;
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
            '.pt-author-enhancements {',
                'padding-left: 3px;',
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
            '.info-pos {',
                'float: left;',
                'width: 19px;',
                'height: 12px;',
                'padding-top: 1px;',
                'margin-top: -4px;',
                'font-size: 120%;',
            '}',
            '.pt-userinfo {',
                'float: left;',
                'font-size: 10px;',
                'padding-top: 5px;',
            '}',
        ].join('');
        $('head').append('<style type="text/css">' + css + '</style>');

        enhanceAuthor($('.post:not(.postit,:last)'));

        document.addEventListener('afterAddPosts', function(e) {
            enhanceAuthor(e.detail);
        });
    });
})(jQuery, window.PowerTools);
