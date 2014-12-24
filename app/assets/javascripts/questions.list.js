Zrquan.module('Questions.List', function(Module, App, Backbone, Marionette, $, _){
    "use strict";

    Module.addInitializer(function() {
        console.log("Questions Show init...");
        Module.controller = new Module.Controller();
        Module.controller.start();
    });

    Module.Controller = Marionette.Controller.extend({
        start: function() {
            Module.infosView.render();
            Module.loadMoreView.render();
        }
    });

    //问答信息块列表视图
    Module.infosView = new (Backbone.Marionette.CollectionView.extend({
        el: 'div[role=infoblocks]',
        childView: Zrquan.UI.InfoBlocks.InfoBlockView,
        render: function() {
            var that = this;
            this.$('.component-infoblock').each(function(){
                var infoBlockView = new Zrquan.UI.InfoBlocks.InfoBlockView({
                    el:$(this)
                });
                that._addChildView(infoBlockView, that.childView);
            });
            this.$(".timeago").timeago();
            console.log('infosView render')
        }
    }));

    Module.loadMoreView = new (Zrquan.UI.LoadMore.LoadMoreView.extend({
        pullAndRefresh: function()  {
            Module.loadMoreView.switchShowMode(Module.loadMoreView.mode.LOADING);
            Module.loadMoreView.$el.show();
            this.counter ++;
            var that = this;
            var url = "/questions/list?type=" + Module.infosView.$el.data("list-type")
                + "&last_id=" + Module.infosView.$('.component-infoblock:last-child').data("qid");
            Zrquan.Ajax.request({
                url: url,
                type: "GET"
            }).then(function(result) {
                if(result.code == "S_OK") {
                    if(result.data.length == 0) {
                        $(document).off('scroll');
                        that.switchShowMode(Module.loadMoreView.mode.NONE);
                    } else if(that.counter == 1) {
                        that.$el.hide();
                    } else {
                        $(document).off('scroll');
                        that.switchShowMode(Module.loadMoreView.mode.MORE);
                    }
                    for(var i = 0; i < result.data.length; i++) {
                        var infoblockTemplate = result.data[i];
                        var infoBlockView = new Zrquan.UI.InfoBlocks.InfoBlockView({
                            el: $(infoblockTemplate)
                        });
                        Module.infosView._addChildView(infoBlockView);
                    }
                    Module.infosView.$(".timeago").timeago();
                    that.isLoading = false;
                }
            });
        }
    }));

});