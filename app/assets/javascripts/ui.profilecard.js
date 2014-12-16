Zrquan.module('UI.ProfileCard', function(Module, App, Backbone, Marionette, $, _){
    "use strict";

    //个人简介卡片控件
    //只建议通过profile:show方式调用
    Module._profileCardView = new (Backbone.Marionette.ItemView.extend({
        el: '[data-role=profile]',
        ui: {
            content : '.popover-content'
        },
        onShowProfile: function(target, userId) {
            var that = this;
            this.showLoadingTips();
            Zrquan.Ajax.request({
                url: '/users/' + userId + '/profile',
                type: 'GET'
            }).then(function(result) {

            });
        },
        showLoadingTips: function() {
            this.show();
            this.ui.content.empty().append("<div class='profile-card-loading'></div>").show();
        },
        show: function() {
            this.$el.show();
        },
        hide: function() {
            this.$el.hide();
        },
        render: function() {
            this.bindUIElements(); // wire up this.ui, if any
        },
        initialize: function() {
            this.listenTo(Zrquan.appEventBus, 'profile:show', this.onShowProfile);
            console.log("profile service init...");
            Backbone.Marionette.ItemView.prototype.initialize.call(this);
        }

    }))();
});