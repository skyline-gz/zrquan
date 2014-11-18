Zrquan.module('Navbar', function(Module, App, Backbone, Marionette, $, _){
    'use strict';

    var authModal = $('#authModal');
    var activateModal = $('#activateModal');
    var forgetPasswordModal = $('#forgetPasswordModal');

    Module.addInitializer(function() {
        console.log("Module Navbar init...");
        Module.controller = new Module.Controller();
        Module.controller.start();
    });


    Module.View = Marionette.LayoutView.extend({
        el: "div[role=navigation]",
        events: {
            'click #btn-sign-up': 'onClickBtnSignUp',
            'click #btn-sign-in': 'onClickBtnSignIn',
            'mouseover .user-link': 'onShowProfileDropdown'
        },
        onClickBtnSignUp: function(e) {
            this.$('div[role=sign-in]', authModal).hide();
            this.$('div[role=sign-up]', authModal).show();
            authModal.modal('show');
        },
        onClickBtnSignIn: function(e) {
            this.$('div[role=sign-in]', authModal).show();
            this.$('div[role=sign-up]', authModal).hide();
            authModal.modal('show');
        },
        onShowProfileDropdown: function(e) {
            this.$("#top-nav-profile-dropdown").show();
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

    //private function


});