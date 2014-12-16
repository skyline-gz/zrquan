Zrquan.module('UI.ProfileCard', function(Module, App, Backbone, Marionette, $, _){
    "use strict";

    //个人简介卡片控件
    //只建议通过profile:show方式调用
    Module._profileCardView = new (Backbone.Marionette.ItemView.extend({
        el: '[data-role=profile]',
        trigger_el: null,
        current_user_id: null,
        ui: {
            content : '.popover-content'
        },
        onShowProfile: function(target, userId) {
            if (this.$el.is(':visible') && this.current_user_id == userId) {
                return;
            }
            this.current_user_id = userId;
            var that = this;
            this.showLoadingTips();
            this.position(target);
            Zrquan.Ajax.request({
                url: '/users/' + userId + '/profile',
                contentType: 'text/html',
                dataType: "text",
                type: 'GET'
            }).then(function(result) {
                that.ui.content.empty().append(result).show();
            });
        },
        showLoadingTips: function() {
            this.show();
            this.ui.content.empty().append("<div class='profile-card-loading'></div>").show();
        },
        position: function(target) {
            var $target = $(target);
            this.trigger_el = $target;
            var offset = $target.offset();
            var width = $target.width();
            var height = $target.height();
            var top = offset.top + height;
            var left = offset.left + (width / 2) - 60;
            this.$el.css({top : top, left: left});
        },
        show: function() {
            this.$el.show();
        },
        hide: function() {
            this.$el.hide();
        },
        checkAndHide: function(evt) {
            if($(evt.target).hasParent(this.$el).length == 0 &&
                $(evt.target).hasParent(this.trigger_el).length == 0) {
                this.$el.hide();
            }
        },
        initialize: function() {
            this.bindUIElements(); // wire up this.ui, if any
            this.listenTo(Zrquan.appEventBus, 'profile:show', this.onShowProfile);
            this.listenTo(Zrquan.appEventBus, 'profile:hide', this.hide);
            this.listenTo(Zrquan.appEventBus, 'mouseover', this.checkAndHide);
            console.log("profile service init...");
            Backbone.Marionette.ItemView.prototype.initialize.call(this);
        }

    }))();
});