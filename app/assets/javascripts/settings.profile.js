Zrquan.module('Settings.Profile', function(Module, App, Backbone, Marionette, $, _){
    "use strict";

    function matchCompanies(q, cb) {
        var cache_matches = locache.get("ac_companies_" + q);
        if(cache_matches) {
            cb(cache_matches);
            return;
        }

        Zrquan.Ajax.request({
            url: "/automatch",
            data: {query: q, type:"Company"}
        }).then(function(result) {
            if (result['code'] == "S_OK") {
                locache.set("ac_companies_" + q, result['matches'], 60);
                cb(result['matches']);
            }
        });
    }

    $('#company').typeahead({
            hint: true,
            highlight: true,
            minLength: 1
        },{
            name: 'states',
            displayKey: 'value',
            // is compatible with the typeahead jQuery plugin
            source: matchCompanies
        });

    function matchSchools(q, cb) {
        var cache_matches = locache.get("ac_schools_" + q);
        if(cache_matches) {
            cb(cache_matches);
            return;
        }

        Zrquan.Ajax.request({
            url: "/automatch",
            data: {query: q, type:"School"}
        }).then(function(result) {
            if (result['code'] == "S_OK") {
                locache.set("ac_schools_" + q, result['matches'], 60);
                cb(result['matches']);
            }
        });
    }

    $('#school').typeahead({
        hint: true,
        highlight: true,
        minLength: 1
    },{
        name: 'states',
        displayKey: 'value',
        // is compatible with the typeahead jQuery plugin
        source: matchSchools
    });

    var $region = $('#region');
    var $location = $('#location');
    var $industry = $('#industry');

    $region.selectpicker({
        'title' : '区域'
    });

    $location.selectpicker({
        'title' : '城市'
    });

    $industry.selectpicker({
        'title' : '行业'
    });

    if(parseInt($region.val()) == -1) {
        $location.prop('disabled',true);
        $location.selectpicker('refresh');
    }

    $region.change(function(){
        var regionId = parseInt($region.val());
        if (regionId == -1) {
            updateLocationOptions();
            return;
        }
        var url = "/settings/locations?id=" + regionId;

        Zrquan.Ajax.request({
            url: url,
            type: "GET"
        }).then(function(result) {
            if (result['code'] == "S_OK") {
                updateLocationOptions(result.data);
            }
        });
    });

    function updateLocationOptions(locations) {
        locations = locations || [];
        $location.find('option').remove().end();
        for(var i = 0; i < locations.length; i++ ){
            var option = $('<OPTION>').attr('value', locations[i].id).html(locations[i].name);
            $location.append(option);
        }
        if(locations.length) {
            $location.prop('disabled',false);
        } else {
            $location.prop('disabled',true);
        }
        $location.selectpicker('refresh');
    }

    $('#profile-setting-form').on('ajax:success', function(xhr, data, status) {
        if(data.code == "S_OK") {
            var $alertSuccess = $('.alert.alert-success');
            $alertSuccess.show();
            $('.alert-message', $alertSuccess).html("档案保存成功");

            setTimeout(function(){
                $alertSuccess.hide();
            }, 2000)
        }
    });
});