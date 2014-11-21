Zrquan.module('UI', function(Module, App, Backbone, Marionette, $, _) {
    'use strict';
    Zrquan.UI = Zrquan.UI || undefined;
    var navbarEventBus = Module.navbarEventBus;

    //模态框抽象视图,对bootstrap.modal的简单封装
    Module.ModalView = Backbone.Marionette.ItemView.extend({
        modalName: "",
        events: {
          'click button[data-dismiss="modal"]' : 'hideModal'
        },
        showModal: function (modalName) {
            if (modalName && modalName == this.modalName) {
                console.log("modal:" + modalName + " show");
                if (this.$el.data('bs.modal')) {
                    this.$el.data('bs.modal').show();
                } else {
                    this.$el.modal("show");
                    console.log(modalName + "Modal Instance Init...")
                }
            }
        },
        moveCenter: function() {
            this.$el.data('bs.modal').moveCenter();
        },
        hideModal: function () {
            this.$el.data('bs.modal').hide();
        },
        initialize: function() {
            // add events from child
            if (this.events) {
                this.events = _.defaults(this.events, Module.ModalView.prototype.events);
            }
            this.delegateEvents(this.events);

            Backbone.Marionette.ItemView.prototype.initialize.call(this);
        },
        render: function() {
            this.bindUIElements(); // wire up this.ui, if any
            console.log(this.modalName + " Modal View Render...")
        }
    })
});