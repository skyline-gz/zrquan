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
    $( "button" ).click(function() {

    });
});