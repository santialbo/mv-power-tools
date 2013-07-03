window.PowerTools = {
    url: 'http://www.mediavida.com',
    resURL: 'http://www.mvusertools.com',
    version: '0',
    options: {
        get: function(key, deaultValue) {
            key = 'mvpt_' + key;
            var value = localStorage.getItem(key);
            if (!_.isNull(value) && !_.isUndefined(value)) {
                return JSON.parse(value);
            } else if (!_.isNull(deaultValue) && !_.isUndefined(deaultValue)) {
                localStorage.setItem(key, JSON.stringify(deaultValue));
                return deaultValue;
            }
        },
        set: function(key, value) {
            key = 'mvpt_' + key;
                localStorage.setItem(key, JSON.encode(value));
        },
        setDefault: function(key, value) {
            key = 'mvpt_' + key;
            if (_.isNull(localStorage.getItem(key))) {
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
