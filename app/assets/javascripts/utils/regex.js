Zrquan.module('Regex', function(Module, App, Backbone, Marionette, $, _) {
    'use strict';
    var regexObj = {
        ENGLISH_NAME: /^[a-z|A-Z]{0,20}$/,
        CHINESE_NAME: /^[\u4e00-\u9fa5]{0,9}$/,
        PASSWORD: /\w{8,16}/,
        EMAIL: /^\w+[\.\w+]*@([\w]+([\.\w+]+))$/
    };

    _.extend(this, regexObj);
});