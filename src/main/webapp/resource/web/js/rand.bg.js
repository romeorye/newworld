(function($) {

    $.fn.RandBG = function(options) {

        var settings = $.extend({
            ClassPrefix: "bg",
            count: 2
        }, options);
        
        var index = Math.ceil(Math.random() * settings.count * settings.count) % settings.count;
        
        $(this).addClass(settings.ClassPrefix + index);
    };

}(jQuery));