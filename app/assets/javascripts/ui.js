Zrquan.module('UI', function(Module, App, Backbone, Marionette, $, _) {
    'use strict';
    Zrquan.UI = Zrquan.UI || undefined;
    var navbarEventBus = Module.navbarEventBus;

    //模态框抽象视图,对bootstrap.modal的简单封装
    Module.ModalView = Backbone.Marionette.ItemView.extend({
        modalName: "",
        showModal: function (modalName) {
            console.log(modalName + "###" + this.modalName)
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