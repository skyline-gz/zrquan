ZrquanApp.module('Navbar', function(Module, App, Backbone, Marionette, $, _){
    'use strict';

    Module.addInitializer(function() {
        console.log("Module Navbar init...");
        Module.controller = new Module.Controller();
        Module.controller.start();
    });


    Module.View = Marionette.ItemView.extend({
        el: "div[role=navigation]",
        events: {
            'click a': 'onClickLink'
        },
        onClickLink: function(e) {
            this.$('li.active').toggleClass('active', false); // turn previously-selected nav link off
            $(e.target).blur()
                .closest('li').toggleClass('active', true); // turn on new link
        },
        // override: don't really render, since this view just attaches to existing navbar html.
        render: function() {
            this.bindUIElements(); // wire up this.ui, if any
        }
    });


    Module.Controller = Marionette.Controller.extend({
        start: function() {
            this.view = new Module.View();
            this.view.render();
        }
    });

});