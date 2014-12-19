Zrquan.module('UI.ProfileCard', function(Module, App, Backbone, Marionette, $, _){
    "use strict";

    //个人简介卡片控件
    //只建议通过profile:show方式调用
    Module._profileCardView = new (Backbone.Marionette.ItemView.extend({
        el: '[data-role=profile]',
        trigger_el: null,
        current_user_id: null,
        events: {
            'click [data-action="follow"]': 'onFollowClick',
            'click [data-action="un-follow"]': 'onUnFollowClick'
        },
        ui: {
            content : '.popover-content'
        },
        onFollowClick : function(evt) {
            var that = this;
            $.when(Zrquan.Ajax.request({
                url: "/users/" + $(evt.currentTarget).data("target-id") + "/follow"
            })).then(function(result){
                if(result["code"] == "S_OK") {
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'info',content:'关注成功',width:'100px'});
                    $(evt.currentTarget).hide();
                    that.$("[data-action=un-follow]").show();
                    var followerNumEl = that.$("[data-type=followers_num]");
                    var followerNum = parseInt(followerNumEl.data("num")) + 1;
                    followerNumEl.data("num", followerNum).html(followerNum)
                }
            });
        },
        onUnFollowClick : function(evt) {
            var that = this;
            $.when(Zrquan.Ajax.request({
                url: "/users/" + $(evt.currentTarget).data("target-id") + "/un_follow"
            })).then(function(result){
                if(result["code"] == "S_OK") {
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'info',content:'取消关注成功',width:'100px'});
                    $(evt.currentTarget).hide();
                    that.$("[data-action=follow]").show();
                    var followerNumEl = that.$("[data-type=followers_num]");
                    var followerNum = parseInt(followerNumEl.data("num")) - 1;
                    followerNumEl.data("num", followerNum).html(followerNum)
                }
            });
        },
        onShowProfile: function(target, userId) {
            if (this.$el.is(':visible') && this.current_user_id == userId) {
                return;
            }
            this.current_user_id = userId;
            var that = this;
            this.showLoadingTips();
            this.trigger_el = $(target);
            this.position();
            Zrquan.Ajax.request({
                url: '/users/' + userId + '/profile',
                contentType: 'text/html',
                dataType: "text",
                type: 'GET'
            }).then(function(result) {
                that.ui.content.empty().append(result).show();
                that.delegateEvents(this.events);
                that.$el[0].offsetWidth
                that.position();
            });
        },
        showLoadingTips: function() {
            this.show();
            this.ui.content.empty().append("<div class='profile-card-loading'></div>").show();
        },
        position: function() {
            var $target = this.trigger_el;
            var offset = $target.offset();
            var offsetTopToWindow = offset.top - $(window).scrollTop();
            var width = $target.width();
            var height = $target.height();
            var screenHeight = $(window).height();
            var top, left;
            left = offset.left + (width / 2) - 60;
            if(offsetTopToWindow + height/2 < screenHeight/2) {
                this.$el.removeClass("top").addClass("bottom");
                top = offset.top + height;
            } else {
                this.$el.removeClass("bottom").addClass("top");
                top = offset.top - this.$el.outerHeight();
            }
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