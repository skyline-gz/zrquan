var Zrquan = Zrquan || {};

$.fn.hasParent = function(exp) {
    return this.filter(function() {
        return !!$(this).closest(exp).length;
    });
};