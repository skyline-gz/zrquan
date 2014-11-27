Zrquan.module('Settings.Profile', function(Module, App, Backbone, Marionette, $, _){
    "use strict";

    function matchCompanies(q, cb) {
        var matches =[];
        Zrquan.Ajax.request({
            url: "/automatch",
            data: {query: q, type:"company"}
        }).then(function(result) {
            if (result['code'] == "S_OK") {
                $.each(result['matches'], function(i, o){
                    matches.push({ value: o.value });
                });
                cb(matches);
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
        var matches =[];
        Zrquan.Ajax.request({
            url: "/automatch",
            data: {query: q, type:"school"}
        }).then(function(result) {
            if (result['code'] == "S_OK") {
                $.each(result['matches'], function(i, o){
                    matches.push({ value: o.value });
                });
                cb(matches);
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
});