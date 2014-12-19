Zrquan.module('UI.InfoBlocks', function(Module, App, Backbone, Marionette, $, _){
    "use strict";

    Zrquan.UI.InfoBlocks = Zrquan.UI.InfoBlocks || undefined;

    Module.eventBus = new Backbone.Wreqr.EventAggregator();

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
                        that.options.parentView.checkEmptyShow();
                        Zrquan.appEventBus.trigger('poptips:sys',{type:'info', content:'成功删除评论'});
                        that.options.parentView.options.parentView.updateCommentsNum(-1);
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
            var commentContent = this.ui.content.html();
            if ($.trim(commentContent).length > 0 ) {
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
                        that.ui.editorWrapper.hide();
                        var commentView = that.options.parentView.addChild(new Module.InfoBlockCommentItem(result.data[0]),
                            Module.InfoBlockCommentItemView);
                        $('.timeago', commentView.$el).timeago();
                        that.options.parentView.options.parentView.updateCommentsNum(1);
                    }
                    that.ui.content.html('');
                });
            } else {
                Zrquan.appEventBus.trigger('poptips:sys',{type:'error', content:'评论内容不能为空'});
            }
        }
    });

    //评论列表视图
    Module.InfoBlockCommentView = Backbone.Marionette.CompositeView.extend({
        template: '#infoblock-comment-wrapper-template',
        className: 'component-infoblock-comment',
        tagName: 'div',
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
        checkEmptyShow: function() {
            if(this.children.length == 0) {
                this.$el.addClass('empty');
            } else {
                this.$el.removeClass('empty');
            }
        },
        onCancelCommentClick: function(evt) {
            this.options.parentView.onCommentClick(evt);
        },
        onSubmitCommentClick: function(evt) {
            var that = this;
            var commentContent = this.ui.content.html();
            if ($.trim(commentContent).length > 0 ) {
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
                        var commentView = that.addChild(new Module.InfoBlockCommentItem(result.data[0]), Module.InfoBlockCommentItemView);
                        $('.timeago', commentView.$el).timeago();
                        that.options.parentView.updateCommentsNum(1);
                    }
                    that.ui.content.html('');
                    that.checkEmptyShow();
                });
            } else {
                Zrquan.appEventBus.trigger('poptips:sys',{type:'error', content:'评论内容不能为空'});
            }
        }
    });

    //信息块视图
    Module.InfoBlockView = Backbone.Marionette.LayoutView.extend({
        events: {
            'click a.edit-button' : 'onEditButtonClick',
            'click .component-infoblock-good-action' : 'onAgreeAnswerClick',
            'click .component-infoblock-opts-comment': 'onCommentClick',
            'click .component-infoblock-opts-favorites' : 'onFavorClick',
            'click .component-infoblock-opts-follow' : 'onFollowClick',
            'click .show-all-button' : 'onShowAllClick',
            'click .hide-all-button' : 'onHideAllClick',
            'mouseover [data-role=user]' : 'onShowUserProfile',
            'click [data-role=user]' : 'onShowUser'
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
            comment: ".component-infoblock-comment-wrapper"
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
            var answerId = this.$el.data('id');
            var questionId = this.$el.data('qid');
            $.when(Zrquan.Ajax.request({
                url: "/questions/"+ questionId + "/answers/" + answerId + "/agree",
                data: {}
            })).then(function(result) {
                if (result.code == "S_OK") {
                    var agreeNum = parseInt(that.ui.agreeNum.data('num')) + 1;
                    that.ui.agreeNum.data('num', agreeNum).html(agreeNum);
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'info', content:'点赞成功', width:'100px'});
                } else if (result.code == "FA_UNAUTHORIZED") {
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'error', content:'操作失败', width:'100px'});
                }
            });
        },
        onCommentClick: function(evt) {
            if (this.$('.component-infoblock-opts-comment-show').is(":visible")) {
                this.loadNShowComment();
                this.$('.component-infoblock-opts-comment-show').hide();
                this.$('.component-infoblock-opts-comment-hide').css( "display", "inline-block");
            } else {
                this.destroyCommentView();
                this.$('.component-infoblock-opts-comment-show').css( "display", "inline-block");
                this.$('.component-infoblock-opts-comment-hide').hide();
            }
        },
        onFavorClick: function(evt) {
            if (this.$('.component-infoblock-opts-favorites-ok').is(":visible")) {
                this.doBookmark();
                this.$('.component-infoblock-opts-favorites-ok').hide();
                this.$('.component-infoblock-opts-favorites-cancel').css( "display", "inline-block");
            } else {
                this.cancelBookmark();
                this.$('.component-infoblock-opts-favorites-ok').css( "display", "inline-block");
                this.$('.component-infoblock-opts-favorites-cancel').hide();
            }
        },
        onFollowClick: function(evt) {
            if (this.$('.component-infoblock-opts-follow-do').is(":visible")) {
                this.doFollow();
                this.$('.component-infoblock-opts-follow-do').hide();
                this.$('.component-infoblock-opts-follow-undo').css( "display", "inline-block");
            } else {
                this.cancelFollow();
                this.$('.component-infoblock-opts-follow-do').css( "display", "inline-block");
                this.$('.component-infoblock-opts-follow-undo').hide();
            }
        },
        doFollow: function() {
            var that = this;

            $.when(Zrquan.Ajax.request({
                url: "/questions/" + this.$el.data('qid') + "/follow"
            })).then(function(result) {
                if (result.code == "S_OK") {
                    that.updateFollowersNum(1);
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'info', content:'关注成功'});
                } else if(result.code == "FA_UNAUTHORIZED") {
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'error', content:'关注失败'});
                }
            });
        },
        cancelFollow: function() {
            var that = this;

            $.when(Zrquan.Ajax.request({
                url: "/questions/" + this.$el.data('qid') + "/un_follow"
            })).then(function(result) {
                if (result.code == "S_OK") {
                    that.updateFollowersNum(-1);
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'info', content:'取消关注成功'});
                } else if(result.code == "FA_UNAUTHORIZED") {
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'error', content:'取消关注失败'});
                }
            });
        },
        doBookmark: function() {
            var that = this;
            var queryparams = "?type="+ this.$el.attr('data-type') + "&id=" + this.$el.attr('data-id');

            $.when(Zrquan.Ajax.request({
                url: "/bookmarks" + queryparams
            })).then(function(result) {
                if (result.code == "S_OK") {
                    that.updateBookmarksNum(1);
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'info', content:'收藏成功'});
                } else if(result.code == "FA_UNAUTHORIZED") {
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'error', content:'收藏失败'});
                }
            });
        },
        cancelBookmark: function() {
            var that = this;
            var queryparams = "?type="+ this.$el.attr('data-type') + "&id=" + this.$el.attr('data-id');

            $.when(Zrquan.Ajax.request({
                url: "/bookmarks" + queryparams,
                type: "DELETE"
            })).then(function(result) {
                if (result.code == "S_OK") {
                    that.updateBookmarksNum(-1);
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'info', content:'取消收藏成功'});
                } else if(result.code == "FA_UNAUTHORIZED") {
                    Zrquan.appEventBus.trigger('poptips:sys',{type:'error', content:'取消收藏失败'});
                }
            });
        },
        onShowAllClick: function(evt) {
            this.$('.component-infoblock-truncate-content').hide();
            this.$('.component-infoblock-all-content').show();
        },
        onHideAllClick: function(evt) {
            this.$('.component-infoblock-truncate-content').show();
            this.$('.component-infoblock-all-content').hide();
        },
        onShowUserProfile: function(evt) {
            Zrquan.appEventBus.trigger('profile:show', evt.currentTarget, parseInt($(evt.currentTarget).data('id')));
        },
        onShowUser: function(evt) {
            location.href = '/users/' + $(evt.currentTarget).data('url-id');
        },
        updateFollowersNum: function(num) {
            num = num || 0;
            var el_followers = this.$('.followers-num');
            var followersNum = parseInt(el_followers.attr('data-num')) + num;
            el_followers.attr('data-num', followersNum).html(followersNum);
        },
        updateBookmarksNum: function(num) {
            num = num || 0;
            var el_bookmarks = this.$('.bookmarks-num');
            var bookmarksNum = parseInt(el_bookmarks.attr('data-num')) + num;
            el_bookmarks.attr('data-num', bookmarksNum).html(bookmarksNum);
        },
        updateCommentsNum: function(num) {
            num = num || 0;
            var el_comments = this.$('.comments-num');
            var commentsNum = parseInt(el_comments.attr('data-num')) + num;
            el_comments.attr('data-num', commentsNum).html(commentsNum);
        },

        loadNShowComment: function() {
            var that = this;
            var queryparams = "?type="+ this.$el.attr('data-type') + "&id=" + this.$el.attr('data-id');

            $.when(Zrquan.Ajax.request({
                url: "/comments" + queryparams,
                type: "GET"
            })).then(function(result) {
                if (result.code == "S_OK") {
                    var comments = new Module.InfoBlockCommentCollection(result.data);
                    var commentView = new Module.InfoBlockCommentView({
                        collection: comments,
                        attrs: {
                            type: that.$el.attr('data-type'),
                            id: that.$el.attr('data-id')
                        },
                        parentView: that
                    });
                    that.comment.show(commentView);
                    commentView.checkEmptyShow();
                    $('.timeago', that.$el).timeago();
                }
            });
        },
        destroyCommentView: function() {
            if (this.comment.currentView && this.comment.currentView.destroy) {
                this.comment.currentView.destroy();
            }
        },
        render: function() {
            console.log('InfoBlockView render');
            this.bindUIElements(); // wire up this.ui, if any
        },
        initialize: function(options){
//            this.listenTo(Module.infoblocksEventBus, 'comments:reload', function(){
//                that.destroyCommentView();
//                that.loadNShowComment();
//            });
        }
    });
});