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
            'click a.edit-button' : 'onEditButtonClick'
        },
        ui: {
            editButton : '.edit-button',
            editor : '.component-infoblock-editor',
            content: '.component-infoblock-content',
            rawContent: '.component-infoblock-raw-content'
        },
        onEditButtonClick : function (evt) {
            this.ui.content.hide();
            this.ui.editor.show();
            var rawContent = this.ui.rawContent.val();
            var editor = UE.getEditor(this.ui.editor[0], {
                UEDITOR_HOME_URL: '/assets/ueditor/',
                submitButton: true,
                initialFrameHeight: 130,
                initialContent: rawContent,
                autoClearinitialContent: false,
                onSubmitButtonClick: function(e) {
                    var value = editor.getContent();
                    $('#inputContent').val(value);
                    $('#answerForm').submit();
                    return false;
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