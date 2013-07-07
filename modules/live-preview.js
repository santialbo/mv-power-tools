(function($, PowerTools) {
    $(function() {
        // extended-reply-form only works in threads or compose page
        if ($('#tid').length == 0 && !/\/foro\/post.php/.exec(document.URL)) return;
        
        var textarea = $('textarea#cuerpo');
        
        $([ '<div style="width: 620px; height: 100px; resize: vertical; overflow: hidden; margin-bottom: 10px; border: 1px;">',
                '<div class="odd" style="height: inherit; overflow: auto; padding: 10px;">',
                    '<div id="pt-live-preview"></div>',
                '</div>',
            '</div>',
            ].join('\n')).insertBefore(textarea.parent().children().first());

        var updatePreview = function () {
            var cabecera = $('#cabecera');
            var post = 'cabecera=' + (cabecera.length ? cabecera.val() : '') +
                '&' + $('#cuerpo').serialize() + '&' + $('#token').serialize() + '&' + $('#fid').serialize() + '&' + $('#tid').serialize();
            $.post("/foro/acciones_preview.php", post).then(function(res) {
                $('#pt-live-preview').html(JSON.parse(res).cuerpo);
            });
        };

        textarea.bind('input propertychange', _.throttle(updatePreview, 2000));
        $('.extended-reply-form').find('button').click(function() {
            setTimeout(updatePreview, 100);
        });

        $('#smilies').find('a').click(function() {
            setTimeout(updatePreview, 100);
        });

        // 

    });
})(jQuery, window.PowerTools);
