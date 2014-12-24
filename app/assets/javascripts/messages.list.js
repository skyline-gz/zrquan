Zrquan.module('Messages.List', function(Module, App, Backbone, Marionette, $, _){
    "use strict";

    var messageBlocks = $('div[role=messageblocks]');

    Module.addInitializer(function() {
        console.log("Messages List init...");
        Module.controller = new Module.Controller();
        Module.controller.start();
    });

    Module.Controller = Marionette.Controller.extend({
        start: function() {
            Module.loadMoreView.render();
            $('[data-role=user]', messageBlocks).mouseover(onShowUserProfile);
        }
    });

    Module.loadMoreView = new (Zrquan.UI.LoadMore.LoadMoreView.extend({
        pullAndRefresh: function()  {
            this.switchShowMode(Module.loadMoreView.mode.LOADING);
            this.$el.show();
            this.counter ++;
            var that = this;
            var lastDay = $('.day:last-child', messageBlocks);
            var url = "/messages/list?last_id=" + $('.item:last-child', lastDay).data("id");

            Zrquan.Ajax.request({
                url: url,
                type: "GET"
            }).then(function(result) {
                if(result.code == "S_OK") {
                    if(result.data.length == 0) {
                        that.switchShowMode(Module.loadMoreView.mode.NONE);
                    } else if(that.counter == 1) {
                        that.$el.hide();
                    } else {
                        that.switchShowMode(Module.loadMoreView.mode.MORE);
                    }
                    for(var i = 0; i < result.data.length; i++) {
                        var infoblockTemplate = result.data[i];
                        messageBlocks.append(infoblockTemplate);
                    }
                    $('[data-role=user]', messageBlocks).mouseover(onShowUserProfile);
                    that.isLoading = false;
                }
            });
        }
    }));

    function onShowUserProfile(evt) {
        Zrquan.appEventBus.trigger('profile:show', evt.currentTarget, parseInt($(evt.currentTarget).data('id')));
    }
});