Zrquan.module('Navbar', function(Module, App, Backbone, Marionette, $, _){
    'use strict';
    var navbarEventBus = Module.navbarEventBus = new Backbone.Wreqr.EventAggregator();

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
            navbarEventBus.trigger('dropdown:show');
        },
        reloadAvatar: function(url) {
            this.$('img.user-logo').attr("src", url);
        },
        initialize: function() {
            this.listenTo(Zrquan.appEventBus, 'reload:avatar', this.reloadAvatar);
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
            Module.profileDropDownView.render();
        }
    });

    Module.profileDropDownView = new (Marionette.ItemView.extend({
        el: '#top-nav-profile-dropdown',
        events: {
            'click .logout' : 'onClickLogout'
        },
        //点击退出
        onClickLogout : function(){
            $("#top-nav-profile-dropdown").hide();
            $.when(Zrquan.Ajax.request({
                url: "/sessions",
                type: "DELETE"
            })).then(function(result){
                if(result["code"] == "S_OK") {
                    console.log("用户退出成功");
                    location.href = result["redirect"];
                }
            });
        },
        showDropdown : function(){
            this.$el.show();
        },
        checkAndHideDropDown: function(evt) {
            if($(evt.target).hasParent("#top-nav-profile-dropdown,.user-link").length == 0) {
                this.$el.hide();
            }
        },
        initialize: function() {
            this.listenTo(navbarEventBus, 'dropdown:show', this.showDropdown);
            this.listenTo(Zrquan.appEventBus, 'mouseover', this.checkAndHideDropDown);
        },
        render: function() {
            this.bindUIElements(); // wire up this.ui, if any
        }
    }))();
});
