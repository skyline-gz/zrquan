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

    var isLoading = false;

    function init() {
        //初始化漂亮日期
        $(".timeago").timeago();

        //初始化滚动监听
        $(document).scroll(_.throttle(function(){
            var nScrollTop = $(document.body)[0].scrollTop;
            var availableHeight = $(document).height()-$(window).height();
            console.log(nScrollTop, availableHeight);
            if(!isLoading && nScrollTop >= availableHeight/4 * 3){
                isLoading = true;
                console.info("pull to refresh...");
                pullAndRefresh();
            }
        }, 500));
    }

    function pullAndRefresh() {
        var url = "/list_questions?type=" + Module.infosView.$el.data("list-type")
            + "&last_id=" + Module.infosView.$('.component-infoblock:last-child').data("qid");
        Zrquan.Ajax.request({
            url: url,
            type: "GET"
        }).then(function(result) {
            if(result.code == "S_OK") {
                for(var i = 0; i < result.data.length; i++) {
                    var infoblockTemplate = result.data[i];
                    var infoBlockView = new Zrquan.UI.InfoBlocks.InfoBlockView({
                        el: $(infoblockTemplate)
                    });
                    Module.infosView._addChildView(infoBlockView);
                }
                isLoading = false;
            }
        });
    }
});