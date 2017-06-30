$(function() {
    return $.fn.Delay = (function() {
        var timer;
        timer = 0;
        return function(callback, ms) {
            clearTimeout(timer);
            return timer = setTimeout(callback, ms);
        };
    })();
});
