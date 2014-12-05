Zrquan.module('Questions.Show', function(Module, App, Backbone, Marionette, $, _){
    "use strict";
    Module.infoblocksEventBus = new Backbone.Wreqr.EventAggregator();

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

    Module.InfoBlockCommentItem = Backbone.Model.extend({});

    Module.InfoBlockCommentCollection = Backbone.Collection.extend({
        model: Module.InfoBlockCommentItem
    });

    //单条评论的视图
    Module.InfoBlockCommentItemView = Backbone.Marionette.ItemView.extend({
        template: '#infoblock-comment-item-template',
        className: 'component-infoblock-item-comment',
        tagName: 'div',
        events: {
           'click .comment-op-link-reply': 'onReplyCommentClick',
           'click .comment-op-link-delete': 'onDeleteCommentClick',
           'click .comment-editable-opts-submit': 'replyComment',
           'click .comment-editable-opts-cancel': 'cancelReplyComment'
        },
        ui: {
            editorWrapper : '.component-infoblock-item-comment-form',
            content: '.comment-editable'
        },
        onReplyCommentClick: function() {
            if(this.ui.editorWrapper.is(':visible')) {
                this.cancelReplyComment();
            } else {
                this.ui.editorWrapper.show();
            }
        },
        onDeleteCommentClick: function() {
            var that = this;
            var commentId = this.model.attributes.id;
            Zrquan.appEventBus.trigger('modal:sys',{
                type:'confirm',title:'删除评论',content:'你确定要删除该评论吗？', onOK:deleteComment});
            function deleteComment() {
                Zrquan.Ajax.request({
                    url: "/comments",
                    data: {
                        id: commentId
                    },
                    type: "DELETE"
                }).then(function(result) {
                    if (result['code'] == "S_OK") {
                        that.options.parentView.removeChildView(that);
                        Zrquan.appEventBus.trigger('poptips:sys',{type:'info', content:'成功删除评论'});
                    }
                });
            }
        },
        cancelReplyComment: function() {
            this.ui.content.html('');
            this.ui.editorWrapper.hide();
        },
        replyComment: function() {
            var that = this;
            var attrs = this.options.attrs;
            this.ui.editorWrapper.hide();
            var commentContent = this.ui.content.html();
            Zrquan.Ajax.request({
                url: "/comments",
                data: {
                    type: attrs.type,
                    id: attrs.id,
                    replied_comment_id: that.model.attributes.id,
                    content: commentContent
                }
            }).then(function(result) {
                if (result['code'] == "S_OK") {
                    var commentView = that.options.parentView.addChild(new Module.InfoBlockCommentItem(result.data[0]),
                            Module.InfoBlockCommentItemView);
                    $('.timeago', commentView.$el).timeago();
                }
                that.ui.content.html('');
            });
        }
    });

    //评论列表视图
    Module.InfoBlockCommentView = Backbone.Marionette.CompositeView.extend({
        template: '#infoblock-comment-wrapper-template',
        childView: Module.InfoBlockCommentItemView,
        childViewOptions: function(){
           return {
               attrs: this.options.attrs,
               parentView: this        //给子View给予自己的引用
           }
        },
        childViewContainer: '.component-infoblock-comment-list',
        events: {
            'click .component-infoblock-comment-footer .comment-editable-opts-cancel': 'onCancelCommentClick',
            'click .component-infoblock-comment-footer .comment-editable-opts-submit': 'onSubmitCommentClick'

        },
        ui: {
            content: '.component-infoblock-comment-footer .component-infoblock-comment-editable'
        },
        onCancelCommentClick: function() {

        },
        onSubmitCommentClick: function(evt) {
            var that = this;
            var commentContent = this.ui.content.html();
            var attrs = this.options.attrs;
            Zrquan.Ajax.request({
                url: "/comments",
                data: {
                    type: attrs.type,
                    id: attrs.id,
                    content: commentContent
                }
            }).then(function(result) {
                if (result['code'] == "S_OK") {
                    var commentView = that.addChild(new Module.InfoBlockCommentItem(result.data[0]), Module.InfoBlockCommentItemView)
                    $('.timeago', commentView.$el).timeago();
                }
                that.ui.content.html('');
            });
        },
        initialize: function(options){
            console.log(options)
        }
    });


    //信息块视图
    Module.InfoBlockView = Backbone.Marionette.LayoutView.extend({
        events: {
            'click a.edit-button' : 'onEditButtonClick',
            'click .component-infoblock-good-action' : 'onAgreeAnswerClick',
            'click .component-comment': 'onCommentClick'
        },
        ui: {
            editButton : '.edit-button',
            editorWrapper : '.component-infoblock-editor-wrapper',
            editor : '.component-infoblock-editor',
            content: '.component-infoblock-content',
            rawContent: '.component-infoblock-raw-content',
            agreeNum: '.component-infoblock-good-num'
        },
        regions: {
            comment: ".component-infoblock-comment"
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
        onCommentClick: function(evt) {
            this.loadNShowComment();
        },
        loadNShowComment: function() {
            var that = this;
            var queryparams = "?type=Answer" + "&id=" + this.$el.attr('data-id');

            $.when(Zrquan.Ajax.request({
                url: "/comments" + queryparams,
                type: "GET"
            })).then(function(result) {
                if (result.code == "S_OK") {
                    var comments = new Module.InfoBlockCommentCollection(result.data);
                    new Module.InfoBlockCommentView({
                        collection: comments,
                        el: '.component-infoblock-comment',
                        attrs: {
                            type: 'Answer',
                            id: that.$el.attr('data-id')
                        },
                        parentView: this
                    }).render();
                    $('.timeago', that.$el).timeago();
                }
            });
        },
        render: function() {
            console.log('InfoBlockView render');
            this.bindUIElements(); // wire up this.ui, if any
        },
        initialize: function(options){
            var that = this;
            this.attrs = options.attrs;
            this.listenTo(Module.infoblocksEventBus, 'comments:reload', function(){
                that.comment.empty();
                that.loadNShowComment();
            });
        }
    });

    //信息块列表视图
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