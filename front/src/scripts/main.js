require.config({
    paths: {
        jquery: '../vendors/jquery/jquery-1.11.1',
        handlebars: '../vendors/handlebarsjs/handlebars-v1.3.0',
        moderniz: '../vendors/moderniz/moderniz',
        jcorp: '../vendors/jcorp/jquery.jcrop-0.9.12'
    },
    priority: [
        "jquery"
    ]
});

require([
    'jquery',
    'handlebars',
    'component.modal'
    //此处为执行grunt build 命令时，grunt-targetngmodules处理的代码，仅在dist时生成，用于加载template模块
    /*(if target dist)
     ,'templates/carousel',
     'templates/hotMoviesPanel'
     */
], function(
    $,
    handlebars
    /*(if target dist)
     ,carouselTpl,
     hotMoviesPanelTpl
     */
    ) {
    'use strict';
    $(document).ready(function() {
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
    });
});
