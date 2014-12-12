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
        //初始化漂亮日期
        $(".timeago").timeago();

        //初始化【编辑问题】
        $('.question-edit').click(function(evt){
            var url = "/questions/" + $(evt.currentTarget).data("id") + "/edit";
            Zrquan.Ajax.request({
                url: url,
                type: 'GET'
            }).then(function(result) {
                if (result['code'] == "S_OK") {
                    Zrquan.Navbar.navbarEventBus.trigger('modal:show', 'askQuestionModal', true, result.data);
                } else if (result['code'] == "FA_UNAUTHORIZED") {
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'error', content:'没有权限', width: '100px'});
                }
            });
        });

        //初始化【攒写答案】
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