Zrquan.module('Navbar', function(Module, App, Backbone, Marionette, $, _){
    'use strict';

    var authModalView, activateModalView, forgetPasswordModalView;
    var navbarEventBus = new Backbone.Wreqr.EventAggregator();

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
            authModalView.render();
            activateModalView.render();
            forgetPasswordModalView.render();
        }
    });

    //模态框抽象视图
    var ModalView = Backbone.Marionette.ItemView.extend({
        modalName: "",
        showModal: function(modalName) {
            console.log(modalName + " show");
            if(modalName && modalName == this.modalName) {
                this.$el.modal('show');
            }
        },
        hideModal: function() {
            this.$el.modal('hide');
        },
        initialize: function() {
            this.listenTo(navbarEventBus, 'modal:show', this.showModal);
            this.listenTo(navbarEventBus, 'modal:hide', this.showModal);
        },
        render: function() {
            this.bindUIElements(); // wire up this.ui, if any
            console.log(this.modalName + " Modal View Init...")
        }
    });

    //登陆注册模态框视图
    authModalView = new (ModalView.extend({
        el: '#authModal',
        modalName: 'authModal',
        ui: {
            'signInPanel' : 'div[role=sign-in]',
            'signUpPanel' : 'div[role=sign-up]'
        },
        events: {
            'auth:switch' : 'switchAuth',
            'click #btn-switch-sign-in': 'onBtnSwitchSignInClick',
            'click #btn-switch-sign-up': 'onBtnSwitchSignUpClick'
        },
        onBtnSwitchSignInClick: function() {
            navbarEventBus.trigger('auth:switch', 'sign-in');
        },
        onBtnSwitchSignUpClick: function() {
            navbarEventBus.trigger('auth:switch', 'sign-up');
        },
        switchAuth: function(panelName){
            if(panelName == 'sign-up') {
                this.ui.signInPanel.hide();
                this.ui.signUpPanel.show();
            } else if (panelName == 'sign-in') {
                this.ui.signUpPanel.hide();
                this.ui.signInPanel.show();
            }
        },
        initialize: function() {
            this.listenTo(navbarEventBus, 'auth:switch', this.switchAuth);
            ModalView.prototype.initialize.call(this);
        }
    }))();

    //激活成功模态框视图
    activateModalView = new (ModalView.extend({
        el: '#activateModal',
        modalName: 'activateModal',
        events: {

        }
    }))();

    //忘记密码模态框视图
    forgetPasswordModalView = new (ModalView.extend({
        el: '#forgetPasswordModal',
        modalName: 'forgetPasswordModal',
        events: {

        }
    }))();

});
