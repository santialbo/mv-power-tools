(function($, PT) {
    $(function() {
        // author-enhancements only works in threads
        if ($('#tid').length == 0 || /\/foro\/post.php/.exec(document.URL)) return;

        var getUserInfo = function(userId) {
            var url = PT.url + '/id/' + userId;
            return $.get(url).then(function(source) {
                var doc = new DOMParser().parseFromString(source, "text/html");
                var div = $('div.userinfo', doc);
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
                        '<a class="tooltip pt-author-online' + (online ? ' pt-online' : '') + '" href="#" original-title="' + (online ? 'Online' : 'Offline') + '">',
                            '<i class="icon-user"></i>',
                        '</a>',
                        '<a class="tooltip pt-author-mensaje" href="/mensajes/nuevos/' + authorId + '" original-title="Mensaje">',
                            '<i class="icon-envelope-alt"></i>',
                        '</a>',
                        '<a class="tooltip pt-author-firma" href="/id/' + authorId + '/firmas" original-title="Firmas">',
                            '<i class="icon-comments"></i>',
                        '</a>',
                        '<a class="tooltip pt-author-info" original-title="Info" href="#" rel="' + authorId + '">',
                            '<i class="icon-info-sign"></i>',
                        '</a>',
                    '</div>'].join(''));
                $(this).append(enhancements);
                $('.tooltip', enhancements).tipsy();
            });
            $('a.pt-author-info', posts).click(function() {
                var userId = $(this).attr('rel');
                var authorDiv = $(this).parent().parent();
                var infoDiv = $('.pt-userinfo', authorDiv);
                if (infoDiv.length > 0) {
                    infoDiv.toggle();
                } else {
                    getUserInfo(userId).then(function(info) {
                        var thousands = function(num) {
                            return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.');
                        };
                        authorDiv.append([
                            '<dl class="pt-userinfo">',
                                '<dd><strong>' + info.personalInfo[0] + '</strong>' + (info.personalInfo[1] ? ' (' + info.personalInfo[1] + ')' : '') + '</dd>',
                                (info.personalInfo[2] ? '<dd>de ' + info.personalInfo[2] + '</dd>' : ''),
                                (info.lastSeen == 'online' ? '' : '<dd>visto hace ' + info.lastSeen + '</dd>'),
                                '<dd>registro: ' + info.registered + '</dd>',
                                '<dd>posts: ' + thousands(info.forumInfo[0]) + '</dd>',
                                '<dd>visitas: ' + thousands(info.forumInfo[1]) + '</dd>',
                                '<dd><a href="/id/' + userId + '/firmas">firmas: ' + thousands(info.forumInfo[2]) + '</a></dd>',
                            '</dl>',
                            ].join(''));
                    });
                }
                $("div.tipsy").remove();
                return false;
            });
        } 

        var css = [
            '.pt-author-enhancements {',
                'font-size: 140%;',
                'padding-left: 3px;',
            '}',
            '.pt-author-online, .pt-author-mensaje, .pt-author-firma, .pt-author-info {',
                'float: left;',
                'padding-right: 4px;',
            '}',
            '.pt-author-mensaje, .pt-author-firma, .pt-author-info {',
                'color: grey;',
            '}',
            '.pt-author-mensaje:hover, .pt-author-firma:hover, .pt-author-info:hover {',
                'color: rgb(239, 80, 0);',
            '}',
            '.pt-author-online {',
                'color: rgb(128, 0, 0);',
            '}',
            '.pt-online {',
                'color: green',
            '}',
            '.pt-userinfo {',
                'float: left;',
                'font-size: 10px;',
            '}',
        ].join('');
        $('head').append('<style type="text/css">' + css + '</style>');

        enhanceAuthor($('.post:not(.postit,:last)'));

        document.addEventListener('afterAddPosts', function(e) {
            enhanceAuthor(e.detail);
        });
    });
})(jQuery, window.PowerTools);
