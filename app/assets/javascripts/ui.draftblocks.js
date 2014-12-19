Zrquan.module('UI.DraftBlocks', function(Module, App, Backbone, Marionette, $, _){
    "use strict";

    Zrquan.UI.DraftBlocks = Zrquan.UI.DraftBlocks || undefined;
    //草稿块视图
    Module.DraftBlockView = Backbone.Marionette.LayoutView.extend({
        events: {
            'click [data-role=remove]' : 'removeDraft'
        },
        removeDraft: function(evt) {
            var that = this;

            Zrquan.appEventBus.trigger('modal:sys',{
                type:'confirm', title:'删除草稿', content:'你确定要删除这个草稿吗？',
                onOK:function(){
                    var $target = $(evt.currentTarget);
                    Zrquan.Ajax.request({
                        url: '/questions/' + $target.data('qid') + '/answer_drafts/remove'
                    }).then(function(result) {
                        if (result['code'] == "S_OK") {
                            Zrquan.appEventBus.trigger('poptips:sys',{type:'info', content:'成功删除草稿'});
                            that.options.parentView.removeChildView(that);
                        } else if (result['code'] == "FA_RESOURCE_NOT_EXIST") {
                            //no draft do nothing
                        }
                    });
                }
            })
        },
        render: function() {
            console.log('DraftBlockView render');
            this.bindUIElements(); // wire up this.ui, if any
        }
    });
});