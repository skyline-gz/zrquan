Zrquan.module('Users.Show', function(Module, App, Backbone, Marionette, $, _){
    'use strict';
    var usersEventBus = Module.usersEventBus = new Backbone.Wreqr.EventAggregator();
    var enableClientCrop = false && Zrquan.Base.support.file && Zrquan.Base.support.canvas;

    Module.addInitializer(function() {
        console.log("Module Users.Show init...");
        Module.controller = new Module.Controller();
        Module.controller.start();
    });

    Module.Controller = Marionette.Controller.extend({
        start: function() {
            Module.userTopView.render();
            Module.userContentView.render();
            Module.resizeAvatarModalView.render();
        }
    });

    Module.userTopView = new (Marionette.LayoutView.extend({
        el: ".user-top",
        events: {
            'mouseover .user-profile-logo' : 'showChangeAvatarTips',
            'mouseover input[name=picture]' : 'showChangeAvatarTips',
            'click .user-profile-logo-edit-button' : 'onChangeAvatarClick',
            'change input[name=picture]': 'onAvatarSelect'
        },
        showChangeAvatarTips : function() {
            this.$('.user-profile-logo-edit-button').show();
        },
        onChangeAvatarClick : function() {
            //IE6 ~ 9 因安全机制不能用JS触发input click事件
            if(!enableClientCrop) {
                this.$("input[name=picture]").click();
            }
        },
        onAvatarSelect : function() {
            var oFile = this.$('input[name=picture]')[0].files[0];
            if(enableClientCrop) {
                usersEventBus.trigger('modal:show', 'resizeAvatarModal', {'file': oFile});
            } else {
                //file onchage 时提交表单到服务器中缓存
                this.$('input[name=handle_mode]').val('cache');
                this.$('#av_up_form').submit();
            }
        },
        checkAndHideChangeAvatarTips : function(evt) {
            if($(evt.target).hasParent(".user-profile-logo,.user-profile-logo-edit-button,input[name=picture]").length == 0) {
                this.$('.user-profile-logo-edit-button').hide();
            }
        },
        reloadAvatar: function(url) {
            this.$('img.user-profile-logo').attr('src', url);
        },
        initialize: function() {
            this.listenTo(Zrquan.appEventBus, 'mouseover', this.checkAndHideChangeAvatarTips);
            this.listenTo(Zrquan.appEventBus, 'reload:avatar', this.reloadAvatar);

            if (enableClientCrop) {
                //使form file input透明，并覆盖到头像区域
                //file onchage 时提交表单
                var offset = this.$('.user-profile-logo').offset();
                offset.top += 75;
                this.$('input[name=picture]').css({
                    'display' : 'block',
                    'z-index' : 9999,
                    'filter' : 'alpha(opacity=0)',
                    '-moz-opacity' : 0,
                    'opacity' : 0,
                    'cursor' : 'pointer'
                }).offset(offset);
            }
        },
        // override: don't really render, since this view just attaches to existing navbar html.
        render: function() {
            this.bindUIElements(); // wire up this.ui, if any
        }
    }))();

    Module.resizeAvatarModalView = new (Zrquan.UI.ModalView.extend({
        el: "#resizeAvatarModal",
        modalName: 'resizeAvatarModal',
        jcrop_api: null,
        jcrop_coords: null,
        dest_id: "",   //仅非HTML5 crop时有用，缓存第一次cache图片的哈希
        ui: {
           'image' : '#jcrop_target',
           'canvas': '#crop_canvas',
           'preview': '#jcrop_preview'
        },
        events: {
            'click .btn-primary' : 'resizeNSaveAvatar'
        },
        _getResizeRatio : function(coords) {
            var holder = this.$('.jcrop-holder')[0];
            return {
                'rx' : 100 / coords.w,
                'ry' : 100 / coords.h,
                'rox' : holder.offsetWidth / this.ui.image[0].width,
                'roy' : holder.offsetHeight / this.ui.image[0].height
            };
        },
        resizeNSaveAvatar: function() {
            var that = this;

            function dataURItoBlob(dataURI) {
                var binary = atob(dataURI.split(',')[1]);
                var array = [];
                for(var i = 0; i < binary.length; i++) {
                    array.push(binary.charCodeAt(i));
                }
                return new Blob([new Uint8Array(array)], {type: 'image/png'});
            }

            if(enableClientCrop) {
                // 如果支持html5，则直接通过canvas绘图截图
                var avatarBase64File = this.cropAvatar(this.jcrop_coords);
                var data = new FormData();
                data.append('picture', dataURItoBlob(avatarBase64File));
                data.append('handle_mode', 'save');

                $.ajax({
                    url: '/upload/upload_avatar',
                    data: data,
                    cache: false,
                    contentType: false,
                    processData: false,
                    type: 'POST',
                    success: function(data){
                        console.log("Client Crop and Server save image success" + data);
                        Zrquan.appEventBus.trigger('reload:avatar', data.url);
                        that.hideModal();
                    }
                });
            } else {
                var coords = this.jcrop_coords;
                var resizeRatio = this._getResizeRatio(coords);

                //第二次提交，可以是xhr方式,提交 jcorp的裁剪结果，返回路径
                var requestObj = {
                    'handle_mode': 'resize',
                    'dest_id' : this.dest_id,
                    'x': Math.round(coords.x / resizeRatio.rox),
                    'y': Math.round(coords.y / resizeRatio.roy),
                    'w': Math.round(coords.w /resizeRatio.rox),
                    'h': Math.round(coords.h /resizeRatio.roy)
                };

                $.when(Zrquan.Ajax.request({
                    url: "/upload/upload_avatar",
                    data: requestObj
                })).then(function(result){
                    if(result["code"] == "S_OK") {
                        console.log("Server Crop and save image success");
                        Zrquan.appEventBus.trigger('reload:avatar', data.url);
                        that.hideModal();
                    }
                });
            }
        },
        cropAvatar: function(coords) {
            var context = this.ui.canvas[0].getContext('2d');
            var resizeRatio = this._getResizeRatio(coords);

            //为Canvas设置背景色,以防透明图片背景变黑
            context.fillStyle = "#fff";
            context.fillRect(0,0,100,100);

            var sourceX = Math.round(coords.x / resizeRatio.rox);
            var sourceY = Math.round(coords.y / resizeRatio.roy);
            var sourceWidth = Math.round(coords.w /resizeRatio.rox);
            var sourceHeight = Math.round(coords.h /resizeRatio.roy);
            context.antialias = 'subpixel';
            context.filter = 'best';
            context.patternQuality = 'best';
            context.oImageSmoothingEnabled = context.mozImageSmoothingEnabled = context.webkitImageSmoothingEnabled = context.imageSmoothingEnabled = true;
            context.drawImage(this.ui.image[0], sourceX, sourceY, sourceWidth, sourceHeight, 0, 0, 100, 100);

            //get the image data from the canvas
            return this.ui.canvas[0].toDataURL("image/png");
        },
        //预览头像
        previewAvatar: function(coords) {
            var oImage = this.ui.image[0];
            var resizeRatio = this._getResizeRatio(coords);

            this.ui.preview.css({
                width: Math.round(resizeRatio.rx * oImage.width * resizeRatio.rox) + 'px',
                height: Math.round(resizeRatio.ry * oImage.height * resizeRatio.roy) + 'px',
                marginLeft: '-' + Math.round(resizeRatio.rx * coords.x) + 'px',
                marginTop: '-' + Math.round(resizeRatio.ry * coords.y) + 'px'
            });
        },
        initJCorp: function() {
            var that = this;
            function onChangeCoords(coords) {
                that.jcrop_coords = _.extend({}, coords);
                that.previewAvatar(coords);
            }

            // destroy Jcrop if it is existed
            if (that.jcrop_api)
                that.jcrop_api.destroy();

            // initialize Jcrop
            $('#jcrop_target').Jcrop({
                setSelect:   [ 0, 0, 32, 32 ],
                minSize: [32, 32], // min crop size
                aspectRatio : 1, // keep aspect ratio 1:1
                bgFade: true, // use fade effect
                bgOpacity: .3, // fade opacity
                onChange: onChangeCoords,
                onSelect: onChangeCoords
            }, function(){
                // Store the Jcrop API in the jcrop_api variable
                that.jcrop_api = this;
            });
        },
        //options格式 {file:file对象(HTML5 Crop有效时使用filer reader加载), url: str(IE9下加载)}
        showModal: function(modalName, options) {
            var that = this;
            var oImage = this.ui.image[0];
            var oPreview = that.ui.preview[0];

            if(enableClientCrop) {
                // prepare HTML5 FileReader
                var oReader = new FileReader();
                oReader.onload = function(e) {
                    // e.target.result contains the DataURL which we can use as a source of the image
                    //todo:检测文件大小和文件类型，出错提示
                    oPreview.src = oImage.src = e.target.result;
                    oImage.onload = function () { // onload event handler
                        that.initJCorp();
                    };
                };
                // read selected file as DataURL
                oReader.readAsDataURL(options.file);
            } else {
                //返回文件路径后，初始化jcrop
                oPreview.src = oImage.src = options.url;
                this.dest_id = options.dest_id;
                oImage.onload = function () { // onload event handler
                    that.initJCorp();
                };
            }

            //super
            Zrquan.UI.ModalView.prototype.showModal.call(this, modalName);

        },
        initialize: function() {
            this.listenTo(usersEventBus, 'modal:show', this.showModal);
        },
        // override: don't really render, since this view just attaches to existing navbar html.
        render: function() {
            this.bindUIElements(); // wire up this.ui, if any
        }
    }))();

    Module.userContentView = new (Marionette.LayoutView.extend({
        el: ".user-content",
        // override: don't really render, since this view just attaches to existing navbar html.
        render: function() {
            this.bindUIElements(); // wire up this.ui, if any
        }
    }))();

});