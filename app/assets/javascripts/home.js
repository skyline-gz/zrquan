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