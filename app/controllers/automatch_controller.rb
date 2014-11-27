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
  #     ioq: 匹配的优先度，结果默认以此排序，即最前匹配的位置
  #     Todo: matches有助于客户端标示匹配的（拼音所匹配到的条目的中文）的起始，暂不实现
  #     matches: [{str : '网络', start: 0, end: 1},
  #               {str : '网络', start: 3, end: 4},
  # 　　　　　　　　{str:'王洛', start:7, end:8}]
  #   },
  #   1:
  #     ...
  #   }
  def companies

    query = 'zhong'

    companies = Company.all

    companies_for_match = []
    companies.each do |o|
      name = o.name
      obj = {
        :s_v => name,
        :s_py => PinYin.permlink(name, ''),
        :s_py1 => PinYin.abbr(name),
        :s_py2 => PinYin.abbr(name, true)
      }
      companies_for_match.push(obj)
    end

    results = []
    companies_for_match.each_with_index do |o, i|
      match_success = o[:s_v].index(query) \
      || o[:s_py].index(query) \
      || o[:s_py1].index(query) \
      || o[:s_py2].index(query)

      if match_success
        results.push({:value => o[:s_v], :ioq => match_success})
      end
    end

    # 根据最先匹配原则，排序所有结果
    results.sort_by! { |k| k[:ioq] }

    render :json => {:code => ReturnCode::S_OK,
                     :matches => results
           }
  end

  def positions

  end

  def schools

  end

  private

end