Zrquan.module('Settings.Password', function(Module, App, Backbone, Marionette, $, _){
    "use strict";
    // just for the demos, avoids form submit
    $.validator.setDefaults({
        debug: true,
        success: "valid",
        errorElement: "label",
        errorClass: "validate-error"
    });
    var form = $( "#password-setting-form" );
    form.validate();
    $( "#op" ).rules( "add", {
        required: true,
        minlength: 8,
        messages: {
            required: "旧密码未填写",
            minlength: $.validator.format("密码包含数字和字母并大于 {0} 位")
        }
    });
    $( "#np" ).rules( "add", {
        required: true,
        minlength: 8,
        messages: {
            required: "新密码未填写",
            minlength: $.validator.format("密码包含数字和字母并大于 {0} 位")
        }
    });
    $( "#rp" ).rules( "add", {
        required: true,
        minlength: 8,
        equalTo: "#np",
        messages: {
            required: "确认密码未填写",
            minlength: $.validator.format("密码包含数字和字母并大于 {0} 位"),
            equalTo: "两次密码输入不一致"
        }
    });
    $( "button" ).click(function() {

    });
});