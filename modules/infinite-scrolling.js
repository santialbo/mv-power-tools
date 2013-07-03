(function($, PowerTools) {
    $(function() {
        // Infinite scrolling only works in threads
        if ($('#tid').length == 0 || /\/foro\/post.php/.exec(document.URL)) return;

        var THREAD_URL = /.*\/foro\/[^\/]+\/[^\/#]+/.exec(document.URL)[0];
        
        var loading = false;
        var page = parseInt($('#pagina')[0].value);
        var pages = [];

        var getInfoFromDocument = function(doc) {
            // Get thread information of a give HTML document
            var page = parseInt($('#pagina', doc)[0].value);
            var last = $('a.last', doc);
            return {
                page: page,
                npages: last.length ? parseInt(last.first().text()) : page,
                posts: $('.post:not(.postit,:last)', doc),
            };
        };

        var getThreadPageInfo = function(threadURL, page) {
            // Get thread information from a given page
            var url = threadURL + '/' + page;
            return $.get(url).then(function(source) {
                var doc = new DOMParser().parseFromString(source, "text/html");
                return getInfoFromDocument(doc);
            });
        };

        var appendPostsToPage = function(posts) {
            // Append posts to the page and update anchors accordingly
            $('#aultimo').remove();
            var $bottompanel = $('#bottompanel');
            posts.each(function(i, post) {
                if (i == posts.length - 1) {
                    $('<a id="aultimo" name="ultimo"></a>').insertBefore($bottompanel);
                }
                var num = $(post).attr('id').replace('post', '');
                $('<a name="' + num + '"></a>').insertBefore($bottompanel);
                $(post).insertBefore($bottompanel);
            });
            document.dispatchEvent(new CustomEvent('afterAddPosts', {
                detail: posts,
                bubbles: false,
                cancelable: false,
            }));
        };

        var updatePagination = function(page) {
            // Update pagination with new information
            var npages = _.last(pages).npages
            var pageLink = function(p, ps) { return '<a ' + ((p == ps) ? 'class="last" ' : '') + 'href="' + THREAD_URL + '/' + p + '">' + p + '</a>'; };
            var paginations = [$('#scrollpages'), $('strong.paginas')];
            paginations[0].children().slice(1).remove()
            paginations[1].children().remove()
            _.each(paginations, function(pagination) {
                if (page >= 4) pagination.append(pageLink(1, npages));
                if (page > 4) pagination.append('<span>...</span>');
                for (var p = Math.max(1, page - 2); p < page; ++p)
                    pagination.append(pageLink(p, npages));
                pagination.append('<em>' + page + '</em>');
                for (p = page + 1; p <= Math.min(npages, page + 2); ++p) {
                    pagination.append(pageLink(p, npages));
                }
                if (page < npages - 3) pagination.append('<span>...</span>');
                if (page <= npages - 3) pagination.append(pageLink(npages, npages));
            });
        };

        var configurePosts = function(posts) {
            // Show +1 and report button on post mouseenter event.
            posts.mouseenter(function() { $('.post_hide', $(this)).show(); })
                .mouseleave(function() { $('.post_hide', $(this)).hide(); });
            $('.masmola', posts).click(function () {
                var counter = $(this).parent().parent().prev().find(".mola");
                var pid = $(this).attr('rel');
                $.post('/foro/post_mola.php', {
                    token: $("#token").val(),
                    tid: $("#tid").val(),
                    num: pid
                }).then(function (res) {
                    if (res == '1') counter.text(parseInt(counter.text()) + 1).fadeIn();
                    else if (res == '-1') alert('Ya has votado este post');
                    else if (res == '-2') alert('No puedes votar más posts hoy');
                    else if (res == '-3') alert('Regístrate para votar posts');
                    else if (res == '-4') alert('No puedes votar este post');
                }).fail(function() {
                    alert('Se ha producido un error, inténtalo más tarde')
                });
                return false;
            });
            // When clicking #XX the reply form gets focus and quotes the post.
            $('.qn', posts).click(function(){
                var pid = $(this).attr('rel');
                var textarea = $('#cuerpo');
                $('#postform').show();
                textarea.focus();
                textarea.val(textarea.val() + '#' + pid + ' ');
                $('html, body').animate({ scrollTop: $(document).height() }, 'fast');
                return false;
            });
        }

        pages.push(getInfoFromDocument(document));
        
        $(window).scroll(function() {
            // Load posts when scroll to the end of the page
            if (loading) return;
            var scroll = $(window).scrollTop() + $(window).height();       
            var bpScroll = $('#bottompanel').offset().top;
            var last = _.last(pages);
            if (scroll > bpScroll && !$('#postform').is(':visible') && last.page < last.npages) {
                loading = true;
                var $sign = $('<div class="alert alert-info" style="text-align: center;"></div>');
                $sign.html('<strong>Cargando respuestas</strong> ...');
                $sign.insertBefore($('#bottompanel'));
                var current = _.last(pages).page;
                getThreadPageInfo(THREAD_URL, current + 1).then(function(info) {
                    pages.push(info);
                    appendPostsToPage(info.posts);
                    $sign.remove();
                    loading = false;
                }).fail(function(){
                    $sign.html('<strong>Error cargando respuestas.</strong> <a href="' + THREAD_URL + '/' + current  +'#aultimo">Recarga la página</a>');
                });
            }
        });

        $(window).scroll(function() {
            // Update pagination when changing page
            var scroll = $(window).scrollTop() + $(window).height();       
            var current;
            for (var i in pages) {
                var first = pages[i].posts[0];
                if ($(first).offset().top < scroll) current = pages[i].page;
                else break;
            }
            if (current != page) {
                updatePagination(current);
                page = current;
            }
        });

        document.addEventListener('afterAddPosts', function(e) {
            configurePosts(e.detail);
        });

        // Automatically load new posts.
        $('#moarnum').remove();
        setInterval(function() {
            var last = _.last(pages);
            if (last.page < last.npages) return;
            var nposts = (last.page - 1)*30 + last.posts.length;
            var tid = $("#tid").val();
            var token = $("#token").val();
            $.get('/foro/moar.php?token=' + token + '&tid=' + tid + '&last=' + nposts).then(function(res) {
                if (res.moar > 0) {
                    getThreadPageInfo(THREAD_URL, last.page).then(function(info) {
                        var newPosts = info.posts.slice(last.posts.length);
                        appendPostsToPage(newPosts);
                        $.merge(last.posts, newPosts);
                        if (info.npages != last.npages) {
                            last.npages = info.npages;
                            updatePagination(page);
                        }
                    });
                }
            });

        }, 30000);

    });
})(jQuery, window.PowerTools);
