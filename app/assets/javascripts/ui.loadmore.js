Zrquan.module('UI.LoadMore', function(Module, App, Backbone, Marionette, $, _) {
    "use strict";

    Zrquan.UI.LoadMore = Zrquan.UI.LoadMore || undefined;

    Module.LoadMoreView = Backbone.Marionette.ItemView.extend({
        el: 'a[data-role=load-more]',
        events: {
            'click': 'onLoadMoreClick'
        },
        mode: {
            "MORE": 1,
            "LOADING": 0,
            "NONE": 2
        },
        counter: 0,                   //下拉刷新的次数，前两次自动加载，然后每次手动加载
        isLoading: false,             //标记是否正在进行下拉刷新
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
                this.pullAndRefresh();
            }
        },
        onScroll: function(evt) {
            var nScrollTop = $(document.body)[0].scrollTop;
            var availableHeight = $(document).height()-$(window).height();
            console.log(nScrollTop, availableHeight);
            if(!this.isLoading && nScrollTop >= availableHeight/5 * 4){
                this.isLoading = true;
                console.info("pull to refresh...");
                this.pullAndRefresh();
            }
        },
        pullAndRefresh:function(){
            //extend this method and do refresh stuff
        },
        render: function() {
            this.listenTo(Zrquan.appEventBus, 'scroll', this.onScroll)
        }
    });
});