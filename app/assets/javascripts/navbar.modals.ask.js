Zrquan.module('Navbar', function(Module, App, Backbone, Marionette, $, _) {
    'use strict';
    var navbarEventBus = Module.navbarEventBus;

    //（问答）提问模态框视图
    Module.askQuestionModuleView = $('#askQuestionModal')[0] ? new (Zrquan.UI.ModalView.extend({
        el: '#askQuestionModal',
        modalName: 'askQuestionModal',
        ui: {
            'themes' : 'input[name="themes"]'
        },
        initialize: function() {
            Zrquan.UI.ModalView.prototype.initialize.call(this);
            this.listenTo(navbarEventBus, 'modal:show', this.showModal);
            this.listenTo(navbarEventBus, 'modal:hide', this.hideModal);
        },
        render: function() {
            Zrquan.UI.ModalView.prototype.render.call(this);
            var that = this;
            this.ui.themes.selectize({
                plugins: ['remove_button'],
                maxItems: 5,
                separator: ',',   //在input框中值的分割符号
                valueField: 'id',
                labelField: 'value',
                searchField: 'value',
                persist: false,
                create: function(input) {
                    navbarEventBus.trigger("modal:show", "createThemeModal");
                    return {
                        value: "",
                        text: ""
                    }
                },
//                render: {
//                    option: function(item, escape) {
//                        return '<div>' + escape(item.value) + '</div>';
//                    }
//                },
                load: function(query, callback) {
                    if (!query.length) return callback();
                    Zrquan.Ajax.request({
                        url: "/automatch",
                        data: {query: query, type:"company"}
                    }).then(function(result) {
                        if(result.code == "S_OK") {
                            callback(result.matches);
                            return;
                        }
                        callback();
                    });
                }
            });
        }
    }))() : undefined;

    //创建主题模态框视图
    Module.createThemeModalView = $('#createThemeModal')[0] ? new (Zrquan.UI.ModalView.extend({
        el: '#createThemeModal',
        modalName: 'createThemeModal',
        ui: {
            //'themes' : 'input[name="themes"]'
        },
        initialize: function() {
            Zrquan.UI.ModalView.prototype.initialize.call(this);
            this.listenTo(navbarEventBus, 'modal:show', this.showModal);
            this.listenTo(navbarEventBus, 'modal:hide', this.hideModal);
        },
        render: function() {
            Zrquan.UI.ModalView.prototype.render.call(this);

        }
    }))() : undefined;
});