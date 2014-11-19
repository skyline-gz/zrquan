Zrquan.module('UI', function(Module, App, Backbone, Marionette, $, _) {
    'use strict';
    var navbarEventBus = Module.navbarEventBus;

    //模态框抽象视图
    Module.ModalView = Backbone.Marionette.ItemView.extend({
        modalName: "",
        showModal: function (modalName) {
            if (modalName && modalName == this.modalName) {
                console.log("modal:" + modalName + " show");
                this.$el.modal('show');
            }
        },
        hideModal: function () {
            this.$el.modal('hide');
        },
        render: function() {
            this.bindUIElements(); // wire up this.ui, if any
            console.log(this.modalName + " Modal View Init...")
        }
    })
});