Zrquan.Ajax = function(){

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
        successCallback = successCallback || $.noop();
        errorCallback = errorCallback || $.noop();
        $.ajax({
            type: options.type,   //访问WebService使用Post方式请求
            contentType: "application/json",
            url: options.url,
            data: JSON.stringify(options.data),
            dataType: 'json',
            success: function(result) {     //回调函数，result，返回值
                console.log(result);
                if(result.code == "S_OK" || result.code == "S_INACTIVE_OK") {
                    deferred.resolve(result);
                } else {
                    deferred.reject();
                }
            }
        });

        return deferred;
    }

    return {
        request: fRequest
    };
}();