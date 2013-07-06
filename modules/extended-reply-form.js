(function($, PowerTools) {
    $(function() {
        // extended-reply-form only works in threads or compose page
        if ($('#tid').length == 0 && !/\/foro\/post.php/.exec(document.URL)) return;
        
        // Remove old buttons
        $('#btsmile').parent().remove();
        
        $([
            '<div class="btn-toolbar extended-reply-form">',
                '<div class="btn-group">',
                    '<button id="form-b" class="btn btn-small" original-title="Negrita" type="button"><i class="icon-bold"></i></button>',
                    '<button id="form-i" class="btn btn-small" original-title="Cursiva" type="button"><i class="icon-italic"></i></button>',
                    '<button id="form-u" class="btn btn-small" original-title="Subrayado" type="button"><i class="icon-underline"></i></button>',
                    '<button id="form-s" class="btn btn-small" original-title="Tachado" type="button"><i class="icon-strikethrough"></i></button>',
                '</div>',
                '<div class="btn-group">',
                    '<button id="form-list" class="btn btn-small" original-title="Lista" type="button"><i class="icon-list"></i></button>',
                    '<button id="form-center" class="btn btn-small" original-title="Centrado" type="button"><i class="icon-align-center"></i></button>',
                '</div>',
                '<div class="btn-group">',
                    '<button id="form-url" class="btn btn-small" original-title="Link" type="button"><i class="icon-link"></i></button>',
                    '<button id="form-img" class="btn btn-small" original-title="Imagen" type="button"><i class="icon-picture"></i></button>',
                    '<button id="form-video" class="btn btn-small" original-title="Video" type="button"><i class="icon-play"></i></button>',
                    '<button id="form-tweet" class="btn btn-small" original-title="Tweet" type="button"><i class="icon-twitter"></i></button>',
                    '<button id="form-audio" class="btn btn-small" original-title="Audio" type="button"><i class="icon-music"></i></button>',
                '</div>',
                '<div class="btn-group">',
                    '<button id="form-spoiler" class="btn btn-small" original-title="Spoiler" type="button">spoiler</button>',
                    '<button id="form-spoiler-named" class="btn btn-small" original-title="Spoiler con nombre" type="button">spoiler=</button>',
                    '<button id="form-nsfw" class="btn btn-small" original-title="NSWF" type="button">NSFW</button>',
                '</div>',
                '<div class="btn-group">',
                    '<button id="form-code" class="btn btn-small" original-title="Código" type="button"><i class="icon-code"></i></button>',
                    '<button id="form-cmd" class="btn btn-small" original-title="Comando" type="button"><i class="icon-terminal"></i></button>',
                '</div>',
                '<div class="btn-group">',
                    '<button id="form-smiley" class="btn btn-small" original-title="Smilies" type="button"><i class="icon-smile"></i></button>',
                '</div>',
            '</div>',
            ].join('')).insertBefore($('textarea#cuerpo'));

        $('.extended-reply-form .btn').tipsy();
        
        var textarea = $('textarea#cuerpo').css('width', '620px');
        
        var bbcodeSimple = function(openTag, closeTag) {
            closeTag = typeof closeTag !== 'undefined' ? closeTag : openTag;
            var start = textarea[0].selectionStart;
            var end = textarea[0].selectionEnd;
            var text = textarea.val();
            var slices = [text.slice(0, start), text.slice(start, end), text.slice(end)];
            textarea.val(slices[0] + '[' + openTag + ']' + slices[1] + '[/' + closeTag + ']' + slices[2]);
            textarea.focus();
            if (start == end) {
                var pos = start + 2 + openTag.length;
                textarea[0].setSelectionRange(pos, pos);
            }
        }
        var bbcodeNamed = function(openTag, closeTag) {
            closeTag = typeof closeTag !== 'undefined' ? closeTag : openTag;
            var start = textarea[0].selectionStart;
            var end = textarea[0].selectionEnd;
            var text = textarea.val();
            var slices = [text.slice(0, start), text.slice(start, end), text.slice(end)];
            textarea.val(slices[0] + '[' + openTag + '=]' + slices[1] + '[/' + closeTag + ']' + slices[2]);
            textarea.focus();
            var pos = start + 2 + openTag.length;
            textarea[0].setSelectionRange(pos, pos);
            if (start == end) {
                textarea[0].setSelectionRange(pos + 1, pos + 1);
            }
        }

        var simpleTags = ['b', 'i', 'u', 's', 'center', 'img', 'video', 'tweet', 'audio', 'spoiler', 'code', 'cmd'];
        $(simpleTags.map(function(tag) { return '#form-' + tag; }).join(', ')).click(function() {
            var tag = $(this).attr('id').replace('form-', '');
            bbcodeSimple(tag);
            return false;
        });

        $('#form-nsfw').click(function() {
            bbcodeSimple('spoiler=NSFW', 'spoiler');
            return false;
        });

        $('#form-url').click(function() {
            bbcodeNamed('url');
            return false;
        });

        $('#form-list').click(function() {
            var start = textarea[0].selectionStart;
            var end = textarea[0].selectionEnd;
            var text = textarea.val();
            var slices = [text.slice(0, start), text.slice(start, end).replace(/^/gm, '* '), text.slice(end)];
            textarea.val(slices[0] + '[list]' + slices[1] + '[/list]' + slices[2]);
            textarea.focus();
            if (start == end) {
                var pos = start + 8;
                textarea[0].setSelectionRange(pos, pos);
            }
            return false;
        });

        $('#form-spoiler-named').click(function() {
            bbcodeNamed('spoiler');
            return false;
        });

        $('#form-smiley').click(function() {
            if ($('div#smilies').is(':visible')) {
                $('div#smilies').hide();
                textarea.css('width', '620px');
            } else {
                $('div#smilies').show();
                textarea.css('width', '490px');
            }
        });

    });
})(jQuery, window.PowerTools);
