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
        events: {

        },
        showModal: function(modalName, oFile) {

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
            }

            var oImage = this.$("#jcrop_target")[0];

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
                    var jcrop_api, boundx, boundy;

                    // destroy Jcrop if it is existed
                    if (typeof jcrop_api != 'undefined')
                        jcrop_api.destroy();

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
                        jcrop_api = this;
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