require 'ruby-pinyin'
require 'returncode_define'

class AutomatchController < ApplicationController
  before_action :authenticate_user!
  before_action :set_query_params, only: [:companies, :positions]

  # 匹配公司
  # param: query 'wangluo'
  # 　　　　returnSize 10 可指定返回的记录条数
  # return: {
  #   code: 'S_OK'  　操作成功
  #   data: [] 见如下　返回的最大长度，默认10条记录
  #   total: 10  匹配的总长
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
    query = params[:query]
    if query == nil
      render :json => {:code => ReturnCode::FA_INVALID_PARAMETERS}
      return
    end
    terms = get_terms('company')
    total = terms.length
    results = match_and_sort_terms(terms, query)
    render :json => {:code => ReturnCode::S_OK, :matches => results, :total => total}
  end

  def positions

  end

  def schools

  end

  private
  # 匹配并排序结果
  def match_and_sort_terms(terms, query)
    results = []
    terms.each do |o|
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
  end

  # 获取根据类型，获取待匹配类型（company,position,school等）的所有条目
  def get_terms(type)
    terms = TermsCache.instance.read(type)
    if terms
      return terms
    end
    fetch_and_cache_terms(type)
  end

  def fetch_and_cache_terms(type)
    terms = nil
    case type
      when 'company'
        companies = Company.all
        terms = pre_process(companies)
        TermsCache.instance.write(type, terms)
      when 'position'
        # positions = Position.all
      else
    end
    terms
  end

  # 拼音预处理
  def pre_process(terms)
    terms_for_match = []
    terms.each do |o|
      name = o.name
      obj = {
          :s_v => name,
          :s_py => PinYin.permlink(name, ''),
          :s_py1 => PinYin.abbr(name),
          :s_py2 => PinYin.abbr(name, true)
      }
      terms_for_match.push(obj)
    end
    terms_for_match
  end

  # 参数处理
  def set_query_params
    params.permit(:query, :returnSize)
  end
end