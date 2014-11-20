Zrquan.module('Base', function(Module, App, Backbone, Marionette, $, _) {
    'use strict';
    //无任何意义，只为了IDEA识别Zrquan.Base已经被定义
    Zrquan.Base = Zrquan.Base || undefined;

    //浏览器特性检测
    Module.support = function() {
        return {
            file : function () {
                //Full File API support.
                return ( window.FileReader && window.File && window.FileList && window.Blob );
            },
            canvas : function() {
                var elem = document.createElement('canvas');
                return !!(elem.getContext && elem.getContext('2d'));
            }
        }
    }();

    //判断元素的所有父亲节点是否含有该exp的元素
    $.fn.hasParent = function (exp) {
        return this.filter(function () {
            return !!$(this).closest(exp).length;
        });
    };
});