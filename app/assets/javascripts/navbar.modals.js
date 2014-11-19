Zrquan.module('Navbar', function(Module, App, Backbone, Marionette, $, _){
    'use strict';
    var navbarEventBus = Module.navbarEventBus;

    //登陆验证弹出框抽象视图
    var AuthBaseModalView = Zrquan.UI.ModalView.extend({
        //检测用户输入是否合法并从界面显示出错信息
        checkAuthParam: function(sType) {
            var bValid = true;
            if(sType == "sign-up") {
                if(this.checkEmpty("input[name=input-sign-up-first-name]")
                    || this.checkEmpty("input[name=input-sign-up-last-name]")) {
                    this.addErrorTips("#sign-up-name", "请输入姓名");
                    bValid = false;
                } else if (!this.checkName("input[name=input-sign-up-first-name]")
                    || !this.checkName("input[name=input-sign-up-last-name]")) {
                    this.addErrorTips("#sign-up-name", "姓名只能为中英文字符");
                    bValid = false;
                }
                if(this.checkEmpty("input[name=input-sign-up-email]")) {
                    this.addErrorTips("#sign-up-email", "请输入邮箱账号");
                    bValid = false;
                } else if (!Zrquan.Regex.EMAIL.test($("input[name=input-sign-up-email]").val())){
                    this.addErrorTips("#sign-up-email", "请输入合法邮箱账号");
                    bValid = false;
                }
                if(this.checkEmpty("input[name=input-sign-up-password]")) {
                    this.addErrorTips("#sign-up-password", "请输入密码");
                    bValid = false;
                } else if (!Zrquan.Regex.PASSWORD.test($("input[name=input-sign-up-password]").val())){
                    this.addErrorTips("#sign-up-password", "至少为8位字母或数字");
                    bValid = false;
                }
                if(!$("input[name=input-sign-up-service]").is(":checked")) {
                    this.addErrorTips("#sign-up-protocol", "请同意服务协议");
                    bValid = false;
                }
            } else if (sType == "sign-in") {
                if(this.checkEmpty("input[name=input-sign-in-email]")) {
                    this.addErrorTips("#sign-in-email", "请输入邮箱账号");
                    bValid = false;
                } else if (!Zrquan.Regex.EMAIL.test($("input[name=input-sign-in-email]").val())){
                    this.addErrorTips("#sign-in-email", "请输入合法邮箱账号");
                    bValid = false;
                }
                if(this.checkEmpty("input[name=input-sign-in-password]")) {
                    this.addErrorTips("#sign-in-password", "请输入密码");
                    bValid = false;
                } else if (!Zrquan.Regex.PASSWORD.test($("input[name=input-sign-in-password]").val())){
                    this.addErrorTips("#sign-in-password", "至少为8位字母或数字");
                    bValid = false;
                }
            } else if (sType == "reset-password") {
                if(this.checkEmpty("input[name=input-email-reset-password]")) {
                    this.addErrorTips("#reset-password-email", "请输入邮箱账号");
                    bValid = false;
                } else if (!Zrquan.Regex.EMAIL.test($("input[name=input-email-reset-password]").val())){
                    this.addErrorTips("#reset-password-email", "请输入合法邮箱账号");
                    bValid = false;
                }
            }
            return bValid;
        },
        checkEmpty: function(sExp) {
            return $.trim(this.$(sExp).val()).length == 0;
        },
        checkName: function(sExp) {
            var value = this.$(sExp).val();
            return Zrquan.Regex.ENGLISH_NAME.test(value) || Zrquan.Regex.CHINESE_NAME.test(value);
        },
        //在某元素上添加出错提示
        addErrorTips: function(sExp, sError) {
            var eTips = $(document.createElement("DIV")).addClass("modal-input-tips");
            eTips.append(sError);
            this.$(sExp).append(eTips);
        },
        //清除出错提示
        removeErrorTips: function() {
            this.$(".modal-input-tips").remove();
        },
        initialize: function() {
            this.listenTo(navbarEventBus, 'modal:show', this.showModal);
            this.listenTo(navbarEventBus, 'modal:hide', this.hideModal);
        }
    });

    //登陆注册模态框视图
    Module.authModalView = new (AuthBaseModalView.extend({
        el: '#authModal',
        modalName: 'authModal',
        ui: {
            'signInPanel' : 'div[role=sign-in]',
            'signUpPanel' : 'div[role=sign-up]'
        },
        events: {
            'auth:switch' : 'switchAuth',
            'click #btn-switch-sign-in': 'onBtnSwitchSignInClick',
            'click #btn-switch-sign-up': 'onBtnSwitchSignUpClick',
            'click .btn-sign-in': 'onBtnSignInClick',
            'click .btn-sign-up': 'onBtnSignUpClick',
            'click #btn-forget-password': 'onBtnForgetPasswordClick'
        },
        onBtnSwitchSignInClick: function() {
            this.switchAuth('sign-in');
        },
        onBtnSwitchSignUpClick: function() {
            this.switchAuth('sign-up');
        },
        //点击登陆
        onBtnSignInClick: function() {
            var that = this;
            this.removeErrorTips();
            if(this.checkAuthParam("sign-in")){
                var requestObj = {
                    user: {
                        email : this.$("input[name=input-sign-in-email]").val(),
                        password : this.$("input[name=input-sign-in-password]").val(),
                        remember_me : this.$("input[name=input-sign-in-remember-me]").isChecked
                    }
                };

                $.when(Zrquan.Ajax.request({
                    url: "/sessions",
                    data: requestObj
                })).then(function(result){
                    if(result["code"] == "S_OK" || result["code"] == "S_INACTIVE_OK") {
                        that.hideModal();
                        location.href = result["redirect"];
                    } else if (result["code"] == "FA_USER_NOT_EXIT") {
                        that.addErrorTips("#sign-in-email", "用户账号不存在");
                    } else if (result["code"] == "FA_PASSWORD_ERROR") {
                        that.addErrorTips("#sign-in-password", "用户名与密码不匹配");
                    }
                });
            }
        },
        //点击注册
        onBtnSignUpClick: function() {
            var that = this;
            this.removeErrorTips();
            if(this.checkAuthParam("sign-up")){
                var requestObj = {
                    user: {
                        email : this.$("input[name=input-sign-up-email]").val(),
                        password : this.$("input[name=input-sign-up-password]").val(),
                        first_name : this.$("input[name=input-sign-up-first-name]").val(),
                        last_name : this.$("input[name=input-sign-up-last-name]").val()
                    }
                };

                $.when(Zrquan.Ajax.request({
                    url: "/registrations",
                    data: requestObj
                })).then(function(result){
                    if(result["code"] == "S_OK" || result["code"] == "FA_SMTP_AUTHENTICATION_ERROR") {
                        that.hideModal();
                        //注册成功，刷新一次页面
                        location.href = result["redirect"];
                        navbarEventBus.trigger('modal:show', 'activateModal');
                        var matches = Zrquan.Regex.EMAIL.exec(requestObj.user.email);
                        that.$("#activateLink").prop("href", "http://mail." + matches[1]);
                    }else if(result["code"] == "FA_USER_ALREADY_EXIT") {
                        that.addErrorTips("#sign-up-email", "该账号已经存在");
                    }
                });
            }
        },
        //点击忘记密码
        onBtnForgetPasswordClick: function() {
            this.hideModal();
            navbarEventBus.trigger('modal:show', 'forgetPasswordModal');
        },
        //切换登陆/注册窗口
        switchAuth: function(panelName) {
            this.removeErrorTips();
            if(panelName == 'sign-up') {
                this.ui.signInPanel.hide();
                this.ui.signUpPanel.show();
            } else if (panelName == 'sign-in') {
                this.ui.signUpPanel.hide();
                this.ui.signInPanel.show();
            }
        },
        initialize: function() {
            this.listenTo(navbarEventBus, 'auth:switch', this.switchAuth);
            AuthBaseModalView.prototype.initialize.call(this);
        }
    }))();

    //激活成功模态框视图
    Module.activateModalView = new (AuthBaseModalView.extend({
        el: '#activateModal',
        modalName: 'activateModal',
        events: {

        }
    }))();

    //忘记密码模态框视图
    Module.forgetPasswordModalView = new (AuthBaseModalView.extend({
        el: '#forgetPasswordModal',
        modalName: 'forgetPasswordModal',
        events: {
            'click #resetPassword' : 'onClickResetPassword'
        },
        onClickResetPassword: function(){
            var that = this;
            if(this.checkAuthParam("reset-password")){
                that.removeErrorTips();
                var requestObj = {
                    user: {
                        email : $("input[name=input-email-reset-password]").val()
                    }
                };

                $.when(Zrquan.Ajax.request({
                    url: "users/password",
                    data: requestObj
                })).then(function(result) {
                    if (result.code == "S_OK") {
                        //todo: 这里应该在界面提示已发送成功
                        console.log("重设密码邮件发送成功");
                    } else if (result.code == "FA_USER_NOT_EXIT") {
                        that.addErrorTips("#reset-password-email", "用户账号不存在");
                    } else if (result.code == "FA_UNKNOWN_ERROR") {
                        that.addErrorTips("#reset-password-email", "未知错误");
                    }
                });
            }
        }
    }))();
});