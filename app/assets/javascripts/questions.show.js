Zrquan.module('Questions.Show', function(Module, App, Backbone, Marionette, $, _){
    "use strict";
    $(".timeago").timeago();
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
});