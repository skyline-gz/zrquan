Zrquan.module('Navbar', function(Module, App, Backbone, Marionette, $, _) {
    'use strict';
    var navbarEventBus = Module.navbarEventBus;

    //（问答）提问模态框视图
    Module.askQuestionModuleView = $('#askQuestionModal')[0] ? new (Zrquan.UI.ModalView.extend({
        el: '#askQuestionModal',
        modalName: 'askQuestionModal',
        ui: {
            'themes' : 'input[name="question[themes]"]',
            'description' : 'textarea[name="question[content]"]'
        },
        initialize: function() {
            Zrquan.UI.ModalView.prototype.initialize.call(this);
            this.listenTo(navbarEventBus, 'modal:show', this.showModal);
            this.listenTo(navbarEventBus, 'modal:hide', this.hideModal);
        },
        render: function() {
            Zrquan.UI.ModalView.prototype.render.call(this);
            var that = this;
            UE.getEditor(this.ui.description[0], {
                UEDITOR_HOME_URL: '/assets/ueditor/',
                submitButton: false,
                initialFrameHeight:115
            });
            this.ui.themes.selectize({
                plugins: ['remove_button'],
                maxItems: 5,
                separator: ',',   //在input框中值的分割符号
                valueField: 'id',
                labelField: 'value',
                searchField: 'value',
                placeholder: '请输入问题所属主题...',
                persist: false,
                create: function(input) {
                    navbarEventBus.trigger("modal:show", "createThemeModal", input);
                    return {
                        value: "",
                        text: ""
                    }
                },
                load: function(query, callback) {
                    if (!query.length) return callback();
                    //先从localStorage中取
                    var cache_matches = locache.get("ac_themes_" + query);
                    if(cache_matches) {
                        callback(cache_matches);
                        return;
                    }

                    //再从远端进行自动匹配
                    Zrquan.Ajax.request({
                        url: "/automatch",
                        data: {query: query, type:"Theme"}
                    }).then(function(result) {
                        if(result.code == "S_OK") {
                            locache.set("ac_companies_" + query, result.matches, 60);
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
            'themeName' : 'input[name=name]'
        },
        showModal: function(modalName, defaultValue) {
            this.ui.themeName.val(defaultValue);
            //super
            Zrquan.UI.ModalView.prototype.showModal.call(this, modalName);

        },
        initialize: function() {
            Zrquan.UI.ModalView.prototype.initialize.call(this);
            this.listenTo(navbarEventBus, 'modal:show', this.showModal);
            this.listenTo(navbarEventBus, 'modal:hide', this.hideModal);
        },
        render: function() {
            var that = this;
            this.$('#theme-create-form').on('ajax:success', function(xhr, data, status) {
                if(data.code == "S_OK") {
                    console.log(data);
                    var themeName = that.ui.themeName.val();
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'info',content:'创建主题【' + themeName + '】成功'});
                    locache.remove("ac_themes_" + themeName);
                    that.hideModal();
                    Module.askQuestionModuleView.ui.themes[0].selectize.addOption({id:data.data.id, value:data.data.name});
                    Module.askQuestionModuleView.ui.themes[0].selectize.addItem(data.data.id);
                } else if(data.code == "FA_NOT_SUPPORTED_PARAMETERS") {
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'error',content:'输入参数错误'});
                } else if(data.code == "FA_TERM_ALREADY_EXIT") {
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'error',content:'不能创建相同主题'});
                }
                that.$( "input[name=name]").val("");
                that.$( "input[name=description]").val("");
            });
            Zrquan.UI.ModalView.prototype.render.call(this);

        }
    }))() : undefined;
});