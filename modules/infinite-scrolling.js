(function($, PowerTools) {
    $(function() {
        if ($('#tid').length == 0) return;
        
        // Setup
        var BASE_URL = PowerTools.url;
        var THREAD_URL = /\/foro\/[^\/]+\/[^\/#]+/.exec(document.URL)[0];

        var loading = false;
        var loadingSign = $('<div class="alert alert-info" style="text-align:center;"><strong>Cargando respuestas...</stong></div>');
        var page = parseInt($('#pagina')[0].value);
        var pages = 0;
        var tokens = {};
        var firstPosts = {};
        getDocumentInfo($(document));

        $(window).scroll(function() {
            if ($('#postform').is(':visible')) return;
            var scroll = $(window).scrollTop() + $(window).height();       
            var bpScroll = $('#bottompanel').offset().top;
            if (scroll > bpScroll && page < pages && !loading) loadPosts(page + 1);
        }); 
        $(window).scroll(checkPage);
        document.addEventListener('afterAddPosts', function(e) {
            e.detail.posts.each(function() {configurePost(this)});
        });

        function checkPage() {
            // Checks the page being displayed in the window.
            var scrollPosition = $(window).scrollTop() + $(window).height();
            var newPage;
            for (var i in firstPosts) {
                if (scrollPosition > firstPosts[i].offset().top) {
                    newPage = i;
                } else break;
            }
            if (newPage != page) {
                page = parseInt(newPage);
                updatePagination();
            }
        }

        function loadPosts(page) {
            // Fetches the posts from the specified page and inserts them at
            // end of the current thread.
            $('#aultimo').remove();
            loading = true;
            loadingSign.insertBefore($('#bottompanel'));
            var url = BASE_URL + THREAD_URL + '/' + page;
            $.get(url, function(data) {
                var doc = new DOMParser().parseFromString(data, "text/html");
                getDocumentInfo(doc);
                var posts = $('.largecol', doc).children()
                    .not('.tpanel,.postit,#postform,#aprimero,#scrollpages');
                posts.insertBefore($('#bottompanel'));
                // Raise event
                document.dispatchEvent(new CustomEvent('afterAddPosts', {
                        detail: {posts: posts, thread: THREAD_URL, page: page},
                        bubbles: false,
                        cancelable: false,
                    })
                );
                loading = false;
                loadingSign.detach();
            });
        }

        function getDocumentInfo(doc) {
            // Gets the document information and saves it in the thread object
            var last = $('a.last', doc);
            var docPage = parseInt($('#pagina', doc)[0].value);
            pages = (last.length ? parseInt(last.first().text()) : docPage);
            tokens[docPage] = $('#token', doc).val();
            firstPosts[docPage] = $('.odd:first', doc);
        }

        function updatePagination() {
            // Update pagination with new information
            function pageLink(page) {
                var last = (page == pages) ? 'class="last" ' : '';
                return '<a ' + last + 'href="' + THREAD_URL + '/' + page + '">' + page + '</a>';
            };
            var paginations = [$('#scrollpages'), $('strong.paginas')];
            paginations[0].children().slice(1).remove()
            paginations[1].children().remove()
            _.each(paginations, function(pagination) {
                if (page >= 4) pagination.append(pageLink(1));
                if (page > 4) pagination.append('<span>...</span>');
                for (var p = Math.max(1, page - 2); p < page; ++p)
                    pagination.append(pageLink(p));
                pagination.append('<em>' + page + '</em>');
                for (p = page + 1; p <= Math.min(pages, page + 2); ++p) {
                    pagination.append(pageLink(p));
                }
                if (page < pages - 3) pagination.append('<span>...</span>');
                if (page <= pages - 3) pagination.append(pageLink(pages));
            });
        };

        function configurePost(post) {
            // Show +1 and report button on post mouseenter event
            var post_hide = $('.post_hide', $(post));
            $(post).mouseenter(function(){post_hide.show();});
            $(post).mouseleave(function(){post_hide.hide();});
            // Clicking on +1 works
            $(".masmola", $(post)).click(function () {
                var plusOneCounter = $(this).parent().parent().prev().find(".mola");
                var pid = $(this).attr("rel");
                page = Math.floor((parseInt(pid) - 1)/30) + 1;
                $.post("/foro/post_mola.php", {
                    token: tokens[page],
                    tid: $("#tid").val(),
                    num: pid
                }, function (res) {
                    switch (res) {
                        case "1":
                            plusOneCounter.text(parseInt(plusOneCounter.text()) + 1);
                            if (plusOneCounter.is(":hidden")) plusOneCounter.fadeIn();
                            break;
                        case "-1":
                            alert("Ya has votado este post");
                            break;
                        case "-2":
                            alert("No puedes votar más posts hoy");
                            break;
                        case "-3":
                            alert("Regístrate para votar posts");
                            break;
                        case "-4":
                            alert("No puedes votar este post");
                            break;
                        default:
                            alert("Se ha producido un error, inténtalo más tarde");
                            break;
                    }
                });
                return false;
            });
            $(".qn", $(post)).click(function(){
                var pid = $(this).attr("rel");
                var textarea = $('#cuerpo');
                $('#postform').show();
                textarea.focus();
                textarea.val(textarea.val() + '#' + pid + ' ');
                $("html, body").animate({ scrollTop: $(document).height() }, "fast");
                return false;
            });
        }
    });
})(jQuery, window.PowerTools);
