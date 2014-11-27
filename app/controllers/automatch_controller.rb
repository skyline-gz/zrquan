require 'ruby-pinyin'
require "returncode_define.rb"

class AutomatchController < ApplicationController
  before_action :authenticate_user!

  # 匹配公司
  # param: query 'wangluo'
  # 　　　　returnSize 10 可指定返回的记录条数
  # return: {
  #   code: 'S_OK'  　操作成功
  #   data: [] 见如下　返回的最大长度，默认10条记录
  #   matchLength: 10  匹配的总长
  #   0: {
  #     value: '网络易网络有限王洛的公司',
  #     matches: [{str : '网络', start: 0, end: 1},
  #               {str : '网络', start: 3, end: 4},
  # 　　　　　　　　{str:'王洛', start:7, end:8}]
  #   },
  #   1:
  #     ...
  #   }
  def companies
    # companies = Company.all
    str = '网易股份有限公司'
    arr_pin_yin = PinYin.of_string(str)
    arr_abbr_pin_yin = abbr_arr(str)
    arr_abbr_pin_yin_except_lead = abbr_arr(str, true)
    str_pin_yin = PinYin.permlink(str, '')
    str_abbr_pin_yin = PinYin.abbr(str)
    str_abbr_pin_yin_except_lead = PinYin.abbr(str, true)
    render :json => {:code => ReturnCode::S_OK,
                     :arr_pin_yin => arr_pin_yin,
                     :arr_abbr_pin_yin => arr_abbr_pin_yin,
                     :arr_abbr_pin_yin_except_lead => arr_abbr_pin_yin_except_lead,
                     :str=> str,
                     :str_pin_yin => str_pin_yin,
                     :str_abbr_pin_yin => str_abbr_pin_yin,
                     :str_abbr_pin_yin_except_lead => str_abbr_pin_yin_except_lead
           }
  end

  def positions

  end

  def schools

  end

  private
  def abbr_arr(str, except_lead=false, except_english=true)
    result = []
    PinYin.of_string(str).each_with_index do |word, i|
      w = (except_lead && i == 0) || (except_english && word.english?) ? word : word[0]
      result.push(w)
    end
    result
  end
end