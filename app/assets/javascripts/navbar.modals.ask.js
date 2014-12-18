Zrquan.module('Navbar', function(Module, App, Backbone, Marionette, $, _) {
    'use strict';
    var navbarEventBus = Module.navbarEventBus;

    //（问答）提问模态框视图
    Module.askQuestionModuleView = $('#askQuestionModal')[0] ? new (Zrquan.UI.ModalView.extend({
        el: '#askQuestionModal',
        modalName: 'askQuestionModal',
        editor: null,
        cacheMode: false,                  //标记当前问题是否是读取以及写入到localStorage
        ui: {
            'title' : 'input[name="question[title]"]',
            'themes' : 'input[name="question[themes]"]',
            'description' : 'textarea[name="question[content]"]'
        },
        events: {
            'click .hot-themes-wrapper .component-subject' : 'onHotThemesClick',
            'submit form' : 'onQuestionFormSubmit',
            'input input[name="question[title]"]': 'onFormContentChange',
            'propertychange input[name="question[title]"]': 'onFormContentChange',
            'input input[name="question[themes]"]': 'onFormContentChange',
            'propertychange input[name="question[themes]"]': 'onFormContentChange'
        },
        initialize: function() {
            Zrquan.UI.ModalView.prototype.initialize.call(this);
            this.listenTo(navbarEventBus, 'modal:show', this.showModal);
            this.listenTo(navbarEventBus, 'modal:hide', this.hideModal);
        },
        showModal: function(modalName, isModified, options) {
            options = options || {};
            if(this.checkCurrentModal(modalName)) {
                isModified = isModified || false;
                if(isModified) {
                    this.$('.modal-title').html("修改问题");
                    this.$('.btn-primary').html("保存");
                    this.$('form').attr('action', '/questions/' + options.id);
                    this.$('input[name=_method]').val("PATCH");
                } else {
                    this.$('.modal-title').html("提问");
                    this.$('.btn-primary').html("提交");
                    this.$('form').attr('action', '/questions');
                    this.$('input[name=_method]').val("POST");
                }
                if(options) {
                    var that = this;
                    var title, content, themes;
                    var cacheObj = locache.get(Zrquan.User.email + "_question_draft_form_cache_obj");
                    if(options.cacheMode && cacheObj) {
                        title = cacheObj.title;
                        content = cacheObj.content;
                        themes = cacheObj.themes;
                    } else {
                        title = options.title;
                        content = options.content;
                        themes = options.themes;
                    }

                    if(title) {
                        this.ui.title.val(title);
                    }
                    if(content) {
                        setTimeout(function(){
                            that.editor.setContent(content);
                        }, 300);
                    }
                    if(themes && _.isArray(themes)) {
                        for(var i = 0; i < themes.length; i++ ) {
                            if(!themes[i]) continue;
                            this.ui.themes[0].selectize.addOption({
                                id:themes[i]["id"],
                                value:themes[i]["value"]
                            });
                            this.ui.themes[0].selectize.addItem(themes[i]["id"]);
                        }
                    }
                }
            }
            this.cacheMode = options.cacheMode || false;
            Zrquan.UI.ModalView.prototype.showModal.call(this, modalName);
        },
        onFormContentChange: function(evt) {
            this.saveFormToLocal.call(this);
        },
        saveFormToLocal: _.throttle(function() {
            if(this.cacheMode) {
                var cacheObj = {};
                cacheObj.title = this.ui.title.val();
                cacheObj.content = this.editor.getContent();
                var themeIds = this.ui.themes.val().split(',');
                console.log(themeIds);
                cacheObj.themes = [];
                for(var i = 0; i < themeIds.length; i++ ) {
                    cacheObj.themes.push(this.ui.themes[0].selectize.getOptionData(themeIds[i]));
                }
                locache.set(Zrquan.User.email + "_question_draft_form_cache_obj", cacheObj);
            }
        }, 200),
        hideModal: function() {
            this.saveFormToLocal();
            this.cacheMode = false;
            this.ui.title.val("");
            this.editor.setContent("");
            this.ui.themes[0].selectize.clearOptions();
            Zrquan.UI.ModalView.prototype.hideModal.call(this);
        },
        onHotThemesClick: function(evt) {
            var themeEl = this.$(evt.target);
            var id = parseInt(themeEl.data('id'));
            var value = themeEl.data('value');
            this.ui.themes[0].selectize.addOption({id:id, value:value});
            this.ui.themes[0].selectize.addItem(id);
        },
        onQuestionFormSubmit: function(evt) {
            this.hideAlert();
            if(!Zrquan.Regex.QUESTION_NAME.test(this.$('input[name="question[title]"]').val())) {
                this.showAlert("问题题目需为 8 至 50 个非空字符", "danger");
                return false;
            } else if(!Zrquan.Regex.THEME_IDS.test(this.$('input[name="question[themes]"]').val())) {
                this.showAlert("问题至少需要选择一个合法主题", "danger");
                return false;
            }
            //提问成功，若开启cacheMode时，清空之
            if(this.cacheMode) {
                locache.remove(Zrquan.User.email + "_question_draft_form_cache_obj");
            }
            return true;
        },
        render: function() {
            var that = this;
            Zrquan.UI.ModalView.prototype.render.call(this);
            this.editor = UE.getEditor(this.ui.description[0], {
                submitButton: false,
                initialFrameHeight:115
            });
            this.editor.addListener( 'contentChange', function( editor ) {
                that.onFormContentChange();
            });
            this.ui.themes.selectize({
                plugins: ['remove_button'],
                maxItems: 5,
                separator: ',',   //在input框中值的分割符号
                valueField: 'id',
                labelField: 'value',
                searchField: 'value',
                placeholder: '选择或搜索主题...',
                showSearchIcon: true,
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
                    var themeName = that.ui.themeName.val();
                    Module.askQuestionModuleView.showAlert('创建主题【' + themeName + '】成功', "success");
                    locache.remove("ac_themes_" + themeName);
                    that.hideModal();
                    Module.askQuestionModuleView.ui.themes[0].selectize.addOption({id:data.data.id, value:data.data.name});
                    Module.askQuestionModuleView.ui.themes[0].selectize.addItem(data.data.id);
                } else if(data.code == "FA_NOT_SUPPORTED_PARAMETERS") {
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'error',content:'输入参数错误'});
                } else if(data.code == "FA_RESOURCE_ALREADY_EXIST") {
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'error',content:'不能创建已有主题'});
                }
                that.$( "input[name=name]").val("");
                that.$( "input[name=description]").val("");
            });

            this.$('select[name=theme_type]').selectpicker({
                'title' : '所属主题...'
            });
            Zrquan.UI.ModalView.prototype.render.call(this);
        }
    }))() : undefined;

});