Zrquan.module('Questions.Show', function(Module, App, Backbone, Marionette, $, _){
    "use strict";

    Module.addInitializer(function() {
        console.log("Questions Show init...");
        Module.controller = new Module.Controller();
        Module.controller.start();
    });

    Module.Controller = Marionette.Controller.extend({
        start: function() {
            init();
            Module.infoBlockCollectionView.render();
        }
    });

    Module.InfoBlockView = Backbone.Marionette.ItemView.extend({
        events: {
            'click a.edit-button' : 'onEditButtonClick',
            'click .component-infoblock-good-action' : 'onAgreeAnswerClick'
        },
        ui: {
            editButton : '.edit-button',
            editorWrapper : '.component-infoblock-editor-wrapper',
            editor : '.component-infoblock-editor',
            content: '.component-infoblock-content',
            rawContent: '.component-infoblock-raw-content',
            agreeNum: '.component-infoblock-good-num'
        },
        onEditButtonClick: function (evt) {
            var that = this;
            this.ui.content.hide();
            this.ui.editorWrapper.show();
            var rawContent = this.ui.rawContent.val();
            var editor = UE.getEditor(this.ui.editor[0], {
                UEDITOR_HOME_URL: '/assets/ueditor/',
                submitButton: true,
                cancelButton: true,
                initialFrameHeight: 130,
                initialContent: rawContent,
                submitButtonTipKey: 'saveTip',
                autoClearinitialContent: false,
                onSubmitButtonClick: function(e) {
                    var value = editor.getContent();
                    $('input[name="answer[content]"]', that.ui.editorWrapper).val(value);
                    $('form', that.ui.editorWrapper)[0].submit();
                    return false;
                },
                onCancelButtonClick: function(e) {
                    editor.setHide();
                    that.ui.content.show();
                    that.ui.editorWrapper.hide();
                }
            });
            editor.setShow();
        },
        onAgreeAnswerClick: function(evt) {
            var that = this;
            var answerId = this.$el.attr('data-id');
            $.when(Zrquan.Ajax.request({
                url: "/answers/" + answerId + "/agree",
                data: {}
            })).then(function(result) {
                if (result.code == "S_OK") {
                    var agreeNum = parseInt(that.ui.agreeNum.attr('data-num')) + 1;
                    that.ui.agreeNum.attr('data-num', agreeNum).html(agreeNum);
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'info', content:'点赞成功', width:'100px'});
                } else if (result.code == "FA_UNAUTHORIZED") {
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'error', content:'操作失败', width:'100px'});
                }
            });
        },
        render: function() {
            console.log('InfoBlockView render');
            this.bindUIElements(); // wire up this.ui, if any
        }
    });

    Module.infoBlockCollectionView = new (Backbone.Marionette.CollectionView.extend({
        el: '.question-answer div[role=infoblocks]',
        childView: Module.InfoBlockView,
        render: function() {
            var that = this;
            $('.question-answer .component-infoblock').each(function(){
                var infoBlockView = new Module.InfoBlockView({el:$(this)});
                that._addChildView(infoBlockView, that.childView);
            });
            console.log('infoBlockCollectionView render')
        }
    }))();

    function init() {
        $(".timeago").timeago();
        if ($('#answerContent')[0]) {
            var editor = UE.getEditor('answerContent', {
                UEDITOR_HOME_URL: '/assets/ueditor/',
                submitButton: true,
                initialFrameHeight: 150,
                onSubmitButtonClick: function(e) {
                    var value = editor.getContent();
                    $('#inputContent').val(value);
                    $('#answerForm').submit();
                    return false;
                }
            });
        }
    }
});