Zrquan.module('Ajax', function(Module, App, Backbone, Marionette, $, _){
    'use strict';
    //无任何意义，只为了IDEA识别Zrquan.Ajax已经被定义
    Zrquan.Ajax = Zrquan.Ajax || undefined;
    /**
     * $.ajax的简单封装,直接返回$.defered对象
     * @param options
     *          url
     *          data
     *          type:    默认为POST
     * @param successCallback
     * @param errorCallback
     * @returns {*}
     */
    function fRequest(options, successCallback, errorCallback) {
        var deferred = new $.Deferred();

        options = options || {};
        options.type = options.type || "POST";
        options.data = options.data || "";
        options.dataType = options.dataType || "json";
        options.contentType = options.contentType || "application/json";
        successCallback = successCallback || $.noop();
        errorCallback = errorCallback || $.noop();
        $.ajax({
            type: options.type,
            contentType: options.contentType,
            url: options.url + (options.url.indexOf('?') == -1 ? '?':'&') + "ts=" +  Math.round(new Date().getTime() / 1000),
            data: JSON.stringify(options.data),
            dataType: options.dataType,
            success: function(result) {
                console.log(result);
                deferred.resolve(result);
            }
        });

        return deferred;
    }

    this.request = fRequest;
});