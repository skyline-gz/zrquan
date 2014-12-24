Zrquan = (function(Backbone){
    'use strict';

    var App = new Backbone.Marionette.Application();
    App.appEventBus = new Backbone.Wreqr.EventAggregator();

//    App.addRegions({
//        primaryRegion: "#primary-region"
//    });

//    App.on("initialize:after", function(){
//        if (Backbone.history){
//            Backbone.history.start();
//        }
//    });

    App.appView = new (Marionette.LayoutView.extend({
        el: document,
        events: {
            'mouseover' : 'onMouseOver',
            'scroll' : 'onScroll'
        },
        onMouseOver: function(evt) {
            this._onMouseOverThrottled(evt);
        },
        onScroll: function(evt) {
            this._onScrollThrottled(evt);
        },
        _onMouseOverThrottled: _.throttle(function(evt){
            App.appEventBus.trigger('mouseover', evt);
        }, 200),
        _onScrollThrottled: _.throttle(function(evt){
            App.appEventBus.trigger('scroll', evt);
        }, 500),
        initialize: function() {
            //设置自定义tooltips
            $('.tooltipster').tooltipster({
                theme: 'tooltipster-shadow'
            });
            //添加返回顶部
            $.goup({
                containerColor: "#ccc",
                bottomOffset: "100px",
                locationOffset: "100px"
            });
        }
    }))();

    App.startSubApp = function(appName){
        var currentApp = App.module(appName);
        //console.log('App.startSubApp ' + appName);
        if (App.currentApp === currentApp){ return; }

        if (App.currentApp){
            App.currentApp.stop();
        }

        App.currentApp = currentApp;
        currentApp.start();
    };

    App.commands.setHandler("start:app", App.startSubApp, App);

    return App;
})(Backbone);