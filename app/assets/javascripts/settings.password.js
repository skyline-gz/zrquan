Zrquan.module('Settings.Password', function(Module, App, Backbone, Marionette, $, _){
    "use strict";
    $.validator.setDefaults({
        success: "valid",
        errorElement: "label",
        errorClass: "validate-error"
    });
    var form = $( "#password-setting-form" );
    var validator = form.validate();
    $( "#current_password" ).rules( "add", {
        required: true,
        minlength: 8,
        messages: {
            required: "旧密码未填写",
            minlength: $.validator.format("密码包含数字和字母并大于 {0} 位")
        }
    });
    $( "#password" ).rules( "add", {
        required: true,
        minlength: 8,
        messages: {
            required: "新密码未填写",
            minlength: $.validator.format("密码包含数字和字母并大于 {0} 位")
        }
    });
    $( "#password_confirmation" ).rules( "add", {
        required: true,
        minlength: 8,
        equalTo: "#password",
        messages: {
            required: "确认密码未填写",
            minlength: $.validator.format("密码包含数字和字母并大于 {0} 位"),
            equalTo: "两次密码输入不一致"
        }
    });
    form.on('ajax:success', function(xhr, data, status) {
        if(data.code == "S_OK") {
            Zrquan.appEventBus.trigger('poptips:sys',{type:'info',content:'修改密码成功'});
        } else if(data.code == "FA_PASSWORD_ERROR") {
            Zrquan.appEventBus.trigger('poptips:sys',{type:'error',content:'原密码输入错误'});
        } else if(data.code == "FA_PASSWORD_INCONSISTENT") {
            Zrquan.appEventBus.trigger('poptips:sys',{type:'error',content:'新密码于密码确认不一致'});
        }
        $( "#current_password").val("");
        $( "#password").val("");
        $( "#password_confirmation" ).val("");
        validator.resetForm();
    });
});