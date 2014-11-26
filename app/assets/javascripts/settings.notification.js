Zrquan.module('Settings.Password', function(Module, App, Backbone, Marionette, $, _){
    "use strict";

    Module.addInitializer(function() {
        console.log("Module Settings.Password init...");
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
        },
        syncCheckboxState: function() {
            this.$('a[data-role=checkbox]').each(function(){
               if($(this).attr("data-checked") == "true") {
                   $(this).addClass("icon-selected");
               } else {
                   $(this).removeClass("icon-selected");
               }
            });
        },
        initialize: function() {
            this.syncCheckboxState();
        },
        // override: don't really render, since this view just attaches to existing navbar html.
        render: function() {
            this.bindUIElements(); // wire up this.ui, if any
        }
    });
});