Zrquan.module('Questions.Show', function(Module, App, Backbone, Marionette, $, _){
    "use strict";
    $(".timeago").timeago();
    UE.getEditor('answerContent', {
        UEDITOR_HOME_URL: '/assets/ueditor/',
        submitButton: true,
        initialFrameHeight: 150
    });
});