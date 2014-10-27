require.config({
    paths: {
        jquery: '../vendors/jquery/jquery-1.11.1',
        handlebars: '../vendors/handlebarsjs/handlebars-v1.3.0',
        moderniz: '../vendors/moderniz/moderniz'
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
        $('#btn-sign-up').click(function(){
            $('#myModal').modal('show')
        });
    });
});
