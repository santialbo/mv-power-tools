// ==UserScript==
// @name        mv-power-tools
// @namespace   santialbo/mv-power-tools
// @version     0
// @description Adds extra features for mediavida.com
// @grant       GM_addStyle
// @include     http://www.mediavida.com/*
// @require     http://code.jquery.com/jquery-1.10.1.min.js
// @require     http://cdn.craig.is/js/mousetrap/mousetrap.min.js
// @require     http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min.js
// ==/UserScript==

window.PowerTools = {
    version: '0',
    options: {
        get: function(key, defvalue) {
            key = 'mvpt_' + key;
            var value = localStorage.getItem(key);
            if (value !== null && typeof value !== 'undefined') {
                return JSON.parse(value);
            } else if (defvalue !== null && typeof defvalue !== 'undefined') {
                localStorage.setItem(key, JSON.stringify(defvalue));
                return defvalue;
            }
        },
        set: function(key, value) {
            key = 'mvpt_' + key;
                localStorage.setItem(key, JSON.encode(value));
        },
        setDefault: function(key, value) {
            key = 'mvpt_' + key;
            if (localStorage.getItem(key) === null) {
                localStorage.setItem(key, JSON.encode(value));
            }
        }
    }
};

// Initial configuration
(function($, PowerTools) {
    $(function() {
        PowerTools.user = $('a.lu').html();
    });
})(jQuery, window.PowerTools);
