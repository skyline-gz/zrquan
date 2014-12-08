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
            Module.questionView.render();
            Module.answersView.render();
        }
    });

    //问题信息块视图
    Module.questionView = new Zrquan.UI.InfoBlocks.InfoBlockView({
        el:'.question-body .component-infoblock',
        attrs: {
            type: 'Question'
        }
    });

    //答案列表视图
    Module.answersView = new (Backbone.Marionette.CollectionView.extend({
        el: '.question-answer div[role=infoblocks]',
        childView: Zrquan.UI.InfoBlocks.InfoBlockView,
        render: function() {
            var that = this;
            this.$('.component-infoblock').each(function(){
                var infoBlockView = new Zrquan.UI.InfoBlocks.InfoBlockView({
                    el:$(this),
                    attrs: {
                        type: 'Answer'
                    }
                });
                that._addChildView(infoBlockView, that.childView);
            });
            console.log('answersView render')
        }
    }));

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