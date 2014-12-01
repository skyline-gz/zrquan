Zrquan.module('Settings.Profile', function(Module, App, Backbone, Marionette, $, _){
    "use strict";

    function matchCompanies(q, cb) {
        var matches =[];
        var cache_matches = locache.get("ac_companies_" + q);
        if(cache_matches) {
            cb(cache_matches);
            return;
        }

        Zrquan.Ajax.request({
            url: "/automatch",
            data: {query: q, type:"company"}
        }).then(function(result) {
            if (result['code'] == "S_OK") {
                $.each(result['matches'], function(i, o){
                    matches.push({ value: o.value });
                });
                locache.set("ac_companies_" + q, matches, 60);
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
        var cache_matches = locache.get("ac_schools_" + q);
        if(cache_matches) {
            cb(cache_matches);
            return;
        }

        Zrquan.Ajax.request({
            url: "/automatch",
            data: {query: q, type:"school"}
        }).then(function(result) {
            if (result['code'] == "S_OK") {
                $.each(result['matches'], function(i, o){
                    matches.push({ value: o.value });
                });
                locache.set("ac_schools_" + q, matches, 60);
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