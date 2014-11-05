$(document).ready(function() {
    var RegEnglishName = /^[a-z|A-Z]{0,20}$/;
    var RegChineseName = /^[\u4e00-\u9fa5]{0,9}$/;
    var RegPassword =/\w{8,16}/;
    var RegEmail = /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/;

    var authModal = $('#authModal');
    $('#btn-sign-up').click(function(){
        $('div[role=sign-in]', authModal).hide();
        $('div[role=sign-up]', authModal).show();
        authModal.modal('show');
    });

    $("#btn-sign-in").click(function(){
        $('div[role=sign-in]', authModal).show();
        $('div[role=sign-up]', authModal).hide();
        authModal.modal('show');
    });

    $("#btn-switch-sign-up").click(function(){
        $('div[role=sign-in]', authModal).hide();
        $('div[role=sign-up]', authModal).show();
    });

    $("#btn-switch-sign-in").click(function(){
        $('div[role=sign-in]', authModal).show();
        $('div[role=sign-up]', authModal).hide();
    });

    $(".top-link-logo").click(function(){
        $('#activateModal').modal('show');
    });

    //点击注册
    $(".btn-sign-up").click(function(){
        removeErrorTips();
        if(checkAuthParam("sign-up")){
            return;
        }
    });

    //点击登陆
    $(".btn-sign-in").click(function(){
        removeErrorTips();
        if(checkAuthParam("sign-in")){
            return;
        }
    });

    $.on("click.dismiss.bs.modal")

    function checkAuthParam(sType) {
        if(sType == "sign-up") {
            if(checkEmpty("input[name=input-sign-up-first-name]")
                || checkEmpty("input[name=input-sign-up-last-name]")) {
                addErrorTips("#sign-up-name", "请输入姓名");
            } else if (!checkName("input[name=input-sign-up-first-name]")
                || !checkName("input[name=input-sign-up-last-name]")) {
                addErrorTips("#sign-up-name", "姓名只能为中英文字符");
            }
            if(checkEmpty("input[name=input-sign-up-email]")) {
                addErrorTips("#sign-up-email", "请输入邮箱账号");
            } else if (!RegEmail.test($("input[name=input-sign-up-email]").val())){
                addErrorTips("#sign-up-email", "请输入合法邮箱账号");
            }
            if(checkEmpty("input[name=input-sign-up-password]")) {
                addErrorTips("#sign-up-password", "请输入密码");
            } else if (!RegPassword.test($("input[name=input-sign-up-password]").val())){
                addErrorTips("#sign-up-password", "至少为8位字母或数字");
            }
            if(!$("input[name=input-sign-up-service]").is(":checked")) {
                addErrorTips("#sign-up-protocol", "请同意服务协议");
            }
        } else if (sType == "sign-in") {
            if(checkEmpty("input[name=input-sign-in-email]")) {
                addErrorTips("#sign-in-email", "请输入邮箱账号");
            } else if (!RegEmail.test($("input[name=input-sign-in-email]").val())){
                addErrorTips("#sign-in-email", "请输入合法邮箱账号");
            }
            if(checkEmpty("input[name=input-sign-in-password]")) {
                addErrorTips("#sign-in-password", "请输入密码");
            } else if (!RegPassword.test($("input[name=input-sign-in-password]").val())){
                addErrorTips("#sign-in-password", "至少为8位字母或数字");
            }
        }
    }

    function checkEmpty(sExp) {
        return $.trim($(sExp).val()).length == 0;
    }

    function checkName(sExp) {
        var value = $(sExp).val();
        return RegEnglishName.test(value) || RegChineseName.test(value);
    }

    function addErrorTips(sExp, sError) {
        var eTips = $(document.createElement("DIV")).addClass("modal-input-tips");
        eTips.append(sError);
        $(sExp).append(eTips);
    }

    function removeErrorTips() {
        $(".modal-input-tips", authModal).remove();
    }
});