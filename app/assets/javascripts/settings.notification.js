Zrquan.module('Settings.Notification', function(Module, App, Backbone, Marionette, $, _){
    "use strict";

    Module.addInitializer(function() {
        console.log("Module Settings.Notification init...");
        Module.controller = new Module.Controller();
        Module.controller.start();
    });

    Module.Controller = Marionette.Controller.extend({
        start: function() {
            this.view = new Module.View();
            this.view.render();
        }
    });

    Module.View = Marionette.LayoutView.extend({
        el: ".user-setting",
        events: {
            'click a[data-role=checkbox]': 'onClickAnchorCheckbox'
        },
        onClickAnchorCheckbox: function(evt) {
            var el = evt.currentTarget;
            if ($(el).attr("data-checked") == "true") {
                $(el).attr("data-checked", "false").removeClass("icon-selected");
            } else {
                $(el).attr("data-checked", "true").addClass("icon-selected");
            }
            var requestObj = {
                'user_msg_setting': {}
            };

            requestObj['user_msg_setting'][$(el).attr("data-attr")] = $(el).attr("data-checked");

            $.when(Zrquan.Ajax.request({
                url: "/settings/notification",
                data: requestObj
            })).then(function(result) {
                if (result.code == "S_OK") {
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'info', content:'设置成功', width:'100px'});
                } else if (result.code == "FA_UNKNOWN_ERROR") {
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'error', content:'未知错误', width:'100px'});
                }
            });
        },
        // override: don't really render, since this view just attaches to existing navbar html.
        render: function() {
            this.bindUIElements(); // wire up this.ui, if any
        }
    });
});