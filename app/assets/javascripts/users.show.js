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
        initialize: function() {
            this.listenTo(Zrquan.appEventBus, 'mouseover', this.checkAndHideChangeAvatarTips);
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
        ui: {
           'image' : '#jcrop_target',
            'holder': '.jcrop-holder',
            'canvas': '#crop_canvas'
        },
        events: {
            'click .btn-primary' : 'resizeNSaveAvatar'
        },
        _getResizeRatio : function(coords) {
            var bounds = this.jcrop_api.getBounds();
            return {
                'rx' : 100 / coords.w,
                'ry' : 100 / coords.h,
                'rox' : this.ui.holder[0].offsetWidth / bounds[0],
                'roy' : this.ui.holder[0].offsetHeight / bounds[1]
            };
        },
        resizeNSaveAvatar: function() {

        },
        cropAvatar: function(coords) {
            var context = this.ui.canvas.getContext('2d');
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
            context.imageSmoothingEnabled = true;
            context.drawImage(this.ui.image, sourceX, sourceY, sourceWidth, sourceHeight, destX, destY, destWidth, destHeight);

            //get the image data from the canvas
            return this.ui.canvas.toDataURL("image/png");
        },
        showModal: function(modalName, oFile) {
            var that = this;
            //预览头像
            function showCoords(coords) {
//                console.log(c.x + " " + c.y + " " + c.x2 + " " + c.y2 + " " + c.w + " " + c.h);
                var rox = $('.jcrop-holder')[0].offsetWidth / oImage.width;
                var roy = $('.jcrop-holder')[0].offsetHeight / oImage.height;

                var rx = 100 / coords.w;
                var ry = 100 / coords.h;

                $('#jcrop_preview').css({
                    width: Math.round(rx * oImage.width * rox) + 'px',
                    height: Math.round(ry * oImage.height * roy) + 'px',
                    marginLeft: '-' + Math.round(rx * coords.x) + 'px',
                    marginTop: '-' + Math.round(ry * coords.y) + 'px'
                });

                // 如果支持html5，则直接通过canvas绘图截图
                //为Canvas设置背景色,以防透明图片背景变黑
                context.fillStyle = "#fff";
                context.fillRect(0,0,100,100);

                var sourceX = Math.round(coords.x / rox);
                var sourceY = Math.round(coords.y / roy) ;
                var sourceWidth = Math.round(coords.w /rox);
                var sourceHeight = Math.round(coords.h /roy);
                var destWidth = 100;
                var destHeight = 100;
                var destX = 0;
                var destY = 0;
                context.imageSmoothingEnabled = true;
                context.drawImage(oImage, sourceX, sourceY, sourceWidth, sourceHeight, destX, destY, destWidth, destHeight);

                //get the image data from the canvas
                var imageData = oCanvas.toDataURL("image/png");
                console.log(imageData);
            }

            var oImage = this.$("#jcrop_target")[0];
            var oCanvas = this.$("#crop_canvas")[0];
            var context = oCanvas.getContext('2d');

            // prepare HTML5 FileReader
            var oReader = new FileReader();
            oReader.onload = function(e) {

                // e.target.result contains the DataURL which we can use as a source of the image
                oImage.src = e.target.result;
                $('#jcrop_preview')[0].src = e.target.result;
                oImage.onload = function () { // onload event handler

                    // display some basic image info
//                        var sResultFileSize = bytesToSize(oFile.size);
//                        $('#filesize').val(sResultFileSize);
//                        $('#filetype').val(oFile.type);
//                        $('#filedim').val(oImage.naturalWidth + ' x ' + oImage.naturalHeight);

                    // Create variables (in this scope) to hold the Jcrop API and image size
                    var boundx, boundy;

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
                        onChange: showCoords,
                        onSelect: showCoords
//                            onRelease: clearInfo
                    }, function(){

                        // use the Jcrop API to get the real image size
                        var bounds = this.getBounds();
                        boundx = bounds[0];
                        boundy = bounds[1];

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