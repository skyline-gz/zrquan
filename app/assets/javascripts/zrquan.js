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
 * 调试相关
 **/
//跨浏览器debug支持
//= require consolelog
//支持IE8/IOS6-/Safari 11-的console debug
//= require consolelog.detailprint
/**
 * 基本库
 **/
//= require underscore
//= require jquery
//支持rails ajax提交表单
//= require jquery_ujs
//= require backbone
//= require backbone.marionette
//支持html5缓存记录
//= require locache
/**
 * 插件
 **/
//支持input控件输入的validate
//= require jquery.validate
//漂亮的tooltips
//= require jquery.tooltipster
//twitter的自动完成库
//= require typeahead.jquery
//标签＆下拉表单库
//= require selectize
//百度开源编辑器ueditor
//= require ueditor/zrquan.config.js
//= require ueditor/ueditor.all.js
//= require ueditor/lang/zh-cn/zh-cn.js
/**
 * 组件
 **/
//= require ./components/component.transition
//= require ./components/component.modal
//= require ./components/component.modalmanager
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
//= require ui
//= require navbar
//= require navbar.modals.auth
//= require navbar.modals.ask
/**
 * 初始化页面Application
 **/
Zrquan.start();