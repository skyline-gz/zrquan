Zrquan.module('Navbar', function(Module, App, Backbone, Marionette, $, _){
    'use strict';
    Module.navbarEventBus = Module.navbarEventBus || new Backbone.Wreqr.EventAggregator();
    var navbarEventBus = Module.navbarEventBus;

    Module.addInitializer(function() {
        console.log("Module Navbar init...");
        Module.controller = new Module.Controller();
        Module.controller.start();
    });

    //导航栏主视图
    Module.View = Marionette.LayoutView.extend({
        el: "div[role=navigation]",
        events: {
            'click #btn-sign-up': 'onClickBtnSignUp',
            'click #btn-sign-in': 'onClickBtnSignIn',
            'mouseover .user-link': 'onShowProfileDropdown'
        },
        onClickBtnSignUp: function(e) {
            navbarEventBus.trigger('auth:switch', 'sign-up');
            navbarEventBus.trigger('modal:show', 'authModal');
        },
        onClickBtnSignIn: function(e) {
            navbarEventBus.trigger('auth:switch', 'sign-in');
            navbarEventBus.trigger('modal:show', 'authModal');
        },
        onShowProfileDropdown: function(e) {
            this.$('#top-nav-profile-dropdown').show();
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
            Module.authModalView.render();
            Module.activateModalView.render();
            Module.forgetPasswordModalView.render();
        }
    });

});
