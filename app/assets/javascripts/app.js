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
            'mouseover' : 'onMouseOver'
        },
        onMouseOver: function(evt) {
            this._onMouseOverThrottled(evt);
        },
        _onMouseOverThrottled: _.throttle(function(evt){
            App.appEventBus.trigger('mouseover', evt);
        }, 200),
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

            //初始化faye subscribe
            initNotificationSubscribe();
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

    function initNotificationSubscribe() {
        if (!Zrquan.User.access_token) {
            return;
        }
        var faye = new Faye.Client(Zrquan.User.faye_client_url);
        faye.subscribe("/notifications_count/" + Zrquan.User.access_token, function(result){
            console.log(result);
        });
    }

    return App;
})(Backbone);