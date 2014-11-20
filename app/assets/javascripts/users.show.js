Zrquan.module('Users.Show', function(Module, App, Backbone, Marionette, $, _){
    'use strict';
    var usersEventBus = Module.usersEventBus = new Backbone.Wreqr.EventAggregator();

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
            'click .user-profile-logo-edit-button' : 'onChangeAvatarClick',
            'change #image_file': 'onAvatarSelect'
        },
        showChangeAvatarTips : function() {
            this.$('.user-profile-logo-edit-button').show();
        },
        onChangeAvatarClick : function() {
            $("input[name=image_file]").click();
        },
        onAvatarSelect : function() {
            var oFile = $('#image_file')[0].files[0];
            usersEventBus.trigger('modal:show', 'resizeAvatarModal', oFile);
        },
        checkAndHideChangeAvatarTips : function(evt) {
            if($(evt.target).hasParent(".user-profile-logo,.user-profile-logo-edit-button").length == 0) {
                this.$('.user-profile-logo-edit-button').hide();
            }
        },
        reloadAvatar: function(url) {
            this.$('img.user-profile-logo').attr('src', url);
        },
        initialize: function() {
            this.listenTo(Zrquan.appEventBus, 'mouseover', this.checkAndHideChangeAvatarTips);
            this.listenTo(Zrquan.appEventBus, 'reload:avatar', this.reloadAvatar);
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
            var avatarBase64File = this.cropAvatar(this.jcrop_coords);
            var data = new FormData();
            data.append('picture', dataURItoBlob(avatarBase64File), 'test.png');
            data.append('handle_mode', 'save');

            function dataURItoBlob(dataURI) {
                var binary = atob(dataURI.split(',')[1]);
                var array = [];
                for(var i = 0; i < binary.length; i++) {
                    array.push(binary.charCodeAt(i));
                }
                return new Blob([new Uint8Array(array)], {type: 'image/png'});
            }

            $.ajax({
                url: '/upload/upload_avatar',
                data: data,
                cache: false,
                contentType: false,
                processData: false,
                type: 'POST',
                success: function(data){
                    console.log("ajax.multipart form data success" + data);
                    Zrquan.appEventBus.trigger('reload:avatar', data.url);
                    that.hideModal();
                }
            });
        },
        cropAvatar: function(coords) {
            var context = this.ui.canvas[0].getContext('2d');
            var resizeRatio = this._getResizeRatio(coords);

            // 如果支持html5，则直接通过canvas绘图截图
            //为Canvas设置背景色,以防透明图片背景变黑
            context.fillStyle = "#fff";
            context.fillRect(0,0,100,100);

            var sourceX = Math.round(coords.x / resizeRatio.rox);
            var sourceY = Math.round(coords.y / resizeRatio.roy) ;
            var sourceWidth = Math.round(coords.w /resizeRatio.rox);
            var sourceHeight = Math.round(coords.h /resizeRatio.roy);
            var destWidth = 100;
            var destHeight = 100;
            var destX = 0;
            var destY = 0;
            context.antialias = 'subpixel';
            context.filter = 'best';
            context.patternQuality = 'best';
            context.oImageSmoothingEnabled = context.mozImageSmoothingEnabled = context.webkitImageSmoothingEnabled = context.imageSmoothingEnabled = true;
            context.drawImage(this.ui.image[0], sourceX, sourceY, sourceWidth, sourceHeight, destX, destY, destWidth, destHeight);

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
        showModal: function(modalName, oFile) {
            var that = this;
            function onChangeCoords(coords) {
                that.jcrop_coords = _.extend({}, coords);
                that.previewAvatar(coords);
            }

            var oImage = this.ui.image[0];
            // prepare HTML5 FileReader
            var oReader = new FileReader();
            oReader.onload = function(e) {
                // e.target.result contains the DataURL which we can use as a source of the image
                oImage.src = e.target.result;
                that.ui.preview[0].src = e.target.result;
                oImage.onload = function () { // onload event handler

                    // display some basic image info
//                        var sResultFileSize = bytesToSize(oFile.size);
//                        $('#filesize').val(sResultFileSize);
//                        $('#filetype').val(oFile.type);
//                        $('#filedim').val(oImage.naturalWidth + ' x ' + oImage.naturalHeight);

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
                };
            };

            // read selected file as DataURL
            oReader.readAsDataURL(oFile);

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