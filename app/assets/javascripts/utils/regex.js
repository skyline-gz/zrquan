Zrquan.module('Regex', function(Module, App, Backbone, Marionette, $, _) {
    'use strict';
    //无任何意义，只为了IDEA识别Zrquan.Regex已经被定义
    Zrquan.Regex = Zrquan.Regex || undefined;

    var regexObj = {
        ENGLISH_NAME: /^[a-z|A-Z]{0,20}$/,
        CHINESE_NAME: /^[\u4e00-\u9fa5]{0,9}$/,
        QUESTION_NAME: /^\S{8,50}$/,
        USER_DESC: /^\S{0,25}$/,
        THEME_IDS: /(\d+)(,\d+)*/,
        PASSWORD: /\w{8,16}/,
        EMAIL: /^\w+[\.\w+]*@([\w]+([\.\w+]+))$/
    };

    _.extend(this, regexObj);
});