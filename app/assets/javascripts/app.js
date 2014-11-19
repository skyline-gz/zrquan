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
        onMouseOver: function() {
            this._onMouseOverThrottled(event);
        },
        _onMouseOverThrottled: _.throttle(function(evt){
            App.appEventBus.trigger('mouseover', evt);
        }, 200)
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