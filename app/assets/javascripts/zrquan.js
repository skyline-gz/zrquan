// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
/**
 * 基本库
 **/
//跨浏览器debug支持
//= require consolelog
//支持IE8/IOS6-/Safari 11-的console debug
//= require consolelog.detailprint
//= require underscore
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require backbone
//= require backbone.marionette
/**
 * 组件
 **/
//= require ./components/component.transition
//= require ./components/component.modal
/**
 * Main Module
 **/
//= require app
/**
 * Utils Module
 **/
//= require ./utils/base
//= require ./utils/ajax
//= require ./utils/regex
/**
 * 视图(View) Module
 **/
//= require navbar.modals
//= require navbar
/**
 * 初始化页面Application
 **/
Zrquan.start();