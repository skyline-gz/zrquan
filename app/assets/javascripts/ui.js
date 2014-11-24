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
    //只建议通过Zrquan.appEventBus.trigger('modal:sys',{type:'info',title:'测试提示标题',content:'测试提示内容',onOK:function(){alert('123');}})
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
        //   content: 提示内容
        //   onOK:  点击确认OK按钮的回调
        onSysModalCall : function(options) {
            this.options = _.extend({}, options);
            var tObj = {};
            _.extend(tObj, {
                'title': options.title || '系统提示',
                'type' : options.type || 'info',
                'content': options.content || ''
            });
            if(options.type == 'info') {
                _.extend(tObj, {
                    'strBtnOK': '确认'
                });
            } else if (options.type == 'confirm') {
                _.extend(tObj, {
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
            Module.ModalView.prototype.hideModal.call(this);
        },
        initialize: function() {
            this.listenTo(Zrquan.appEventBus, 'modal:sys', this.onSysModalCall);
            Module.ModalView.prototype.initialize.call(this);
            console.log('System modal service init...');
        }

    }))();

    //Zrquan.appEventBus.trigger('poptips:sys',{type:'info',content:'测试提示内容'})
    Module._sysPopTips = new (Backbone.Marionette.ItemView.extend({
        el: '#popTips',
        queue: [],
        _showing: false,
        template: _.template($('#pop-tips-template').html()),
        onSysPoptipsCall: function(options) {
            this.queue.push(_.extend({}, options));
            if(!this._showing) {
                this._showing = true;
                this.showPopTips(this.queue.pop());
            }
        },
        //options
        //   type: 系统通知类型
        //   content: 通知内容
        //   width:  指定宽度,默认为200px
        showPopTips: function(options) {
            var tObj = {};
            _.extend(tObj, {
                'type' : options.type || 'info',
                'content': options.content || '',
                'width' : options.width || '200px'
            });
            this.instance = this.template(tObj);
            this.$el.append(this.instance);
            this.$el.css("top", "46px");
            //显示5s 后自动收回
            $.support.transition ?
                this.$el
                    .one('bsTransitionEnd', $.proxy(this.hidePopTips, this))
                    .emulateTransitionEnd(250) :
                this.hidePopTips()
        },
        hidePopTips: function(){
            var that = this;
            setTimeout(function(){
                that.$el.css("top", "0px");
                $.support.transition ?
                    that.$el.one('bsTransitionEnd',  $.proxy(that.removePopTips,that)).emulateTransitionEnd(250) :
                    that.removePopTips();
            }, 5000)
        },
        removePopTips: function() {
            this.$el.empty();
            if(this.queue.length > 0) {
                this.showPopTips(this.queue.pop());
            } else {
                this._showing = false;
            }
        },
        render: function() {
            this.bindUIElements(); // wire up this.ui, if any
        },
        initialize: function() {
            this.listenTo(Zrquan.appEventBus, 'poptips:sys', this.onSysPoptipsCall);
            Backbone.Marionette.ItemView.prototype.initialize.call(this);
            console.log("System poptips service init...");
        }
    }))();
});