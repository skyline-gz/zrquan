require "returncode_define.rb"

class AutomatchController < ApplicationController
  before_action :authenticate_user!

  # 匹配公司
  # param: query '网络'
  # return: {
  #   code: 'S_OK'
  #   data: {} 见如下
  # ｝
  #   0: {
  #     value: '网络易网络有限公司',
  #     matches: [{str : '网络', start: 0, end: 1},{str : '网络', start: 3, end: 4}]
  #   },
  #   1:
  #     ...
  #   }
  # param: query 'wangluo'
  # return: {
  #   code: 'S_OK'  操作成功
  #   data: {} 见如下
  # ｝
  #   0: {
  #     value: '网络易网络有限王洛的公司',
  #     matches: [{str : '网络', start: 0, end: 1},
  #               {str : '网络', start: 3, end: 4},{str:'王洛', start:7, end:8}]
  #   },
  #   1:
  #     ...
  #   }
  def companies

  end

  def positions

  end

  def schools

  end
end