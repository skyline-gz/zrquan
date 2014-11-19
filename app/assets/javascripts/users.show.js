Zrquan.module('Users.Show', function(Module, App, Backbone, Marionette, $, _){
    'use strict';
    var usersEventBus = Module.usersEventBus = new Backbone.Wreqr.EventAggregator();

    Module.addInitializer(function() {
        console.log("Module Users.Show init...");
        Module.controller = new Module.Controller();
        Module.controller.start();
    });

    Module.Controller = Marionette.Controller.extend({
        start: function() {
            Module.userTopView.render();
            Module.userContentView.render();
            Module.resizeAvatarModalView.render();
        }
    });

    Module.userTopView = new (Marionette.LayoutView.extend({
        el: ".user-top",
        events: {
            'mouseover .user-profile-logo' : 'showChangeAvatarTips',
            'click .user-profile-logo-edit-button' : 'onChangeAvatarClick',
            'change #image_file': 'onAvatarSelect'
        },
        showChangeAvatarTips : function() {
            this.$('.user-profile-logo-edit-button').show();
        },
        onChangeAvatarClick : function() {
            $("input[name=image_file]").click();
        },
        onAvatarSelect : function() {
//            var oFile = $('#image_file')[0].files[0];
            usersEventBus.trigger('modal:show', 'resizeAvatarModal');
        },
        checkAndHideChangeAvatarTips : function(evt) {
            if($(evt.target).hasParent(".user-profile-logo,.user-profile-logo-edit-button").length == 0) {
                this.$('.user-profile-logo-edit-button').hide();
            }
        },
        initialize: function() {
            this.listenTo(Zrquan.appEventBus, 'mouseover', this.checkAndHideChangeAvatarTips);
        },
        // override: don't really render, since this view just attaches to existing navbar html.
        render: function() {
            this.bindUIElements(); // wire up this.ui, if any
        }
    }))();

    Module.resizeAvatarModalView = new (Zrquan.UI.ModalView.extend({
        el: "#resizeAvatarModal",
        modalName: 'resizeAvatarModal',
        events: {

        },
        showModal: function(args) {
            this.$('#jcrop_target').Jcrop({
                onChange: showCoords,
                onSelect: showCoords
            });

            function showCoords(c) {
                console.log(c.x + " " + c.y + " " + c.x2 + " " + c.y2 + " " + c.w + " " + c.h);
            }

            //super
            Zrquan.UI.ModalView.prototype.showModal.call(this, args);
        },
        initialize: function() {
            this.listenTo(usersEventBus, 'modal:show', this.showModal);
        },
        // override: don't really render, since this view just attaches to existing navbar html.
        render: function() {
            this.bindUIElements(); // wire up this.ui, if any
        }
    }))();

    Module.userContentView = new (Marionette.LayoutView.extend({
        el: ".user-content",
        // override: don't really render, since this view just attaches to existing navbar html.
        render: function() {
            this.bindUIElements(); // wire up this.ui, if any
        }
    }))();

});