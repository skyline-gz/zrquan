Zrquan.module('Base', function(Module, App, Backbone, Marionette, $, _) {
    'use strict';
    //判断元素的所有父亲节点是否含有该exp的元素
    $.fn.hasParent = function (exp) {
        return this.filter(function () {
            return !!$(this).closest(exp).length;
        });
    };
});