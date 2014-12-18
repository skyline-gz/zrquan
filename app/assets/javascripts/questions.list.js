Zrquan.module('Questions.List', function(Module, App, Backbone, Marionette, $, _){
    "use strict";

    Module.addInitializer(function() {
        console.log("Questions Show init...");
        Module.controller = new Module.Controller();
        Module.controller.start();
    });

    Module.Controller = Marionette.Controller.extend({
        start: function() {
            init();
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
            console.log('infosView render')
        }
    }));

    Module.loadMoreView = new (Backbone.Marionette.ItemView.extend({
        el: 'a[data-role=load-more]',
        events: {
           'click': 'onLoadMoreClick'
        },
        mode: {
           "MORE": 1,
           "LOADING": 0,
           "NONE": 2
        },
        switchShowMode: function(mode) {
            this.options.mode = mode;
            switch(mode) {
               case this.mode.MORE:
                   this.$el.empty().html("更多");
                   break;
               case this.mode.LOADING:
                   this.$el.empty().append($("<i>").addClass("spinner-gray")).append("正在加载");
                   break;
               case this.mode.NONE:
                   this.$el.empty().html("没有了");
                   break;
            }
        },
        onLoadMoreClick: function() {
            if(this.options.mode == this.mode.MORE) {
                pullAndRefresh();
            }
        },
        render: function() {

        }
    }));

    var isLoading = false;
    //下拉刷新的次数，前两次自动加载，然后每次手动加载
    var counter = 0;

    function init() {
        //初始化漂亮日期
        $(".timeago").timeago();

        //初始化滚动监听
        $(document).scroll(_.throttle(function(){
            var nScrollTop = $(document.body)[0].scrollTop;
            var availableHeight = $(document).height()-$(window).height();
            console.log(nScrollTop, availableHeight);
            if(!isLoading && nScrollTop >= availableHeight/5 * 4){
                isLoading = true;
                console.info("pull to refresh...");
                pullAndRefresh();
            }
        }, 500));
    }

    function pullAndRefresh() {
        Module.loadMoreView.switchShowMode(Module.loadMoreView.mode.LOADING);
        Module.loadMoreView.$el.show();
        counter ++;

        var url = "/questions/list?type=" + Module.infosView.$el.data("list-type")
            + "&last_id=" + Module.infosView.$('.component-infoblock:last-child').data("qid");
        Zrquan.Ajax.request({
            url: url,
            type: "GET"
        }).then(function(result) {
            if(result.code == "S_OK") {
                if(counter == 1) {
                    Module.loadMoreView.$el.hide();
                } else if(result.data.length == 0) {
                    $(document).off('scroll');
                    Module.loadMoreView.switchShowMode(Module.loadMoreView.mode.NONE);
                } else {
                    $(document).off('scroll');
                    Module.loadMoreView.switchShowMode(Module.loadMoreView.mode.MORE);
                }
                for(var i = 0; i < result.data.length; i++) {
                    var infoblockTemplate = result.data[i];
                    var infoBlockView = new Zrquan.UI.InfoBlocks.InfoBlockView({
                        el: $(infoblockTemplate)
                    });
                    Module.infosView._addChildView(infoBlockView);
                }
                Module.infosView.$(".timeago").timeago();
                isLoading = false;
            }
        });
    }
});