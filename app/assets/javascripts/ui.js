Zrquan.module('UI', function(Module, App, Backbone, Marionette, $, _) {
    'use strict';
    Zrquan.UI = Zrquan.UI || undefined;

    //to use mustache-style brackets  {{= }} (interpolate) and {{ }} (evaluate)
    _.templateSettings = {
        interpolate: /\{\{\=(.+?)\}\}/g,
        evaluate: /\{\{(.+?)\}\}/g
    };

    //模态框抽象视图,对bootstrap.modal的简单封装
    Module.ModalView = Backbone.Marionette.ItemView.extend({
        modalName: "",
        events: {
          'click [data-dismiss="modal"]' : 'hideModal'
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
        attachEvent: function() {
            // add events from child
            if (this.events) {
                this.events = _.defaults(this.events, Module.ModalView.prototype.events);
            }
            this.delegateEvents(this.events);
        },
        initialize: function() {
            this.attachEvent();
            Backbone.Marionette.ItemView.prototype.initialize.call(this);
        },
        render: function() {
            this.bindUIElements(); // wire up this.ui, if any
            console.log(this.modalName + " Modal View Render...")
        }
    });

    //系统的alert, info, error,等模态框的服务
    //只建议通过Zrquan.appEventBus.trigger('modal:sys',{type:'alert',onOK:function(){alert('123');}})
    //方式调用
    Module._sysModalView = new (Module.ModalView.extend({
        el: '#sysModal',
        template: _.template($('#sys-modal-template').html()),
        modalName: 'sysModal',
        events: {
            'click [class*="btn-primary"]' : 'onClickBtnOK'
        },
        options: {},
        instance: null,
        //options
        //   type: 系统模态框类型
        //   title: 系统模态框标题
        //   onOK:  点击确认OK按钮的回调
        onSysModalCall : function(options) {
            this.options = _.extend({}, options);
            var tObj = {};
            _.extend(tObj, {'title': options.title || '系统提示'});
            if(options.type == 'alert') {
                _.extend(tObj, {
                    'enableBtnCancel': undefined,
                    'strBtnOK': '确认'
                });
            } else if (options.type == 'confirm') {
                _.extend(tObj, {
                    'enableBtnCancel': true,
                    'strBtnCancel': '取消',
                    'strBtnOK': '确认'
                });
            }
            this.instance = this.template(tObj);
            this.$el.append(this.instance);
            this.attachEvent();
            this.showModal('sysModal');
        },
        onClickBtnOK: function() {
            if(this.options.onOK) {
                this.options.onOK.call(this);
            }
            this.hideModal();
        },
        hideModal: function () {
            this.$el.empty();
        },
        initialize: function() {
            this.listenTo(Zrquan.appEventBus, 'modal:sys', this.onSysModalCall);
            Backbone.Marionette.ItemView.prototype.initialize.call(this);
            console.log('System modal service init...')
        }

    }))();
});