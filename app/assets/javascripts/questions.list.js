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
                    el:$(this),
                    attrs: {
                        type: $(this).attr('infoblock-type')
                    }
                });
                that._addChildView(infoBlockView, that.childView);
            });
            console.log('infosView render')
        }
    }));

    function init() {
        $(".timeago").timeago();
    }
});