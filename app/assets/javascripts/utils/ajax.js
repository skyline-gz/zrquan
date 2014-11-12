Zrquan = Zrquan || {};
Zrquan.Ajax = function(){

    function fRequest() {
        $.ajax({
            type: "POST",   //访问WebService使用Post方式请求
            contentType: "application/json",
            url: "users",
            data: "{}",  //这里是要传递的参数，格式为 data: "{paraName:paraValue}",下面将会看到
            dataType: 'json',   //WebService 会返回Json类型

            success: function(result) {     //回调函数，result，返回值
                alert(result.d);
            }
        });
    }

    return {
        request: fRequest
    };
};