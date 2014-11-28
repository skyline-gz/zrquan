require 'ruby-pinyin'
require 'returncode_define'

class AutomatchController < ApplicationController
  before_action :authenticate_user!
  before_action :set_query_params

  SUPPORT_TYPE = %w('company', 'school')
  MATCH_TYPE = {
      :value => 's_v',                            #命中原字符串
      :pinyin_value => 's_py',                    #命中字符串的全拼
      :pinyin_value_abbr => 's_py1',              #命中字符串的声母串
      :pinyin_value_abbr_except_lead => 's_py2',  #命中字符串的声母串（原字符串的首个字符不变，仍然是全拼）
  }

  # 匹配公司
  # param: query 'wangluo'
  # 　　　　returnSize 10 可指定返回的记录条数，默认50条记录，最大不超过1000条
  # return: {
  #   code: 'S_OK'  　操作成功
  #   type: 'company' 支持自动匹配的类型，见SUPPORT_TYPE
  #   data: [] 见如下　返回的最大长度
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

  def do_match
    query = params[:query]
    type = params[:type]
    return_size = [params[:returnSize] || 50, 1000].min
    if query == nil || type == nil
      render :json => {:code => ReturnCode::FA_INVALID_PARAMETERS}
      return
    end
    if SUPPORT_TYPE.find { |e| /#{type}/ =~ e }
      terms = get_terms(type)
      results = match_and_sort_terms(terms, query)
      total = results.length
      results = results.slice(0, return_size)
      render :json => {:code => ReturnCode::S_OK, :matches => results, :total => total}
    else
      render :json => {:code => ReturnCode::FA_NOT_SUPPORTED_PARAMETERS}
    end
  end

  private
  # 匹配结果
  # param
  #    terms : object 条目
  #    query : string 关键字
  # return
  #    results : object 匹配结果　id为该类型（如company在compenies表）在所属表中的id,
  # 　　　　　　　　　　　　　　　　　value是匹配命中的字符串值,
  # 　　　　　　　　　　　　　　　　　m_t是匹配命中的类型，见MATCH_TYPE

  def match_and_sort_terms(terms, query)
    results = []
    terms.each do |o|
      MATCH_TYPE.each do |key, value|
        match_success = o[value].index(query)
        if match_success
          results.push({:id => o[:id], :value => o[MATCH_TYPE[:value]], \
          :ioq => match_success, :m_t => value})
          break
        end
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

  # 在modal层取数据，预处理，并放入缓存
  def fetch_and_cache_terms(type)
    terms = nil
    case type
      when 'company'
        companies = Company.all
        terms = pre_process(companies)
        TermsCache.instance.write(type, terms)
      when 'school'
        schools = School.all
        terms = pre_process(schools)
        TermsCache.instance.write(type, terms)
      else
    end
    terms
  end

  # 拼音预处理
  def pre_process(terms)
    terms_for_match = []
    terms.each do |o|
      name = o.name
      obj = {:id => o.id}
      obj[MATCH_TYPE[:value]] = name
      obj[MATCH_TYPE[:pinyin_value]] = PinYin.permlink(name, '')
      obj[MATCH_TYPE[:pinyin_value_abbr]] = PinYin.abbr(name)
      obj[MATCH_TYPE[:pinyin_value_abbr_except_lead]] = PinYin.abbr(name, true)
      terms_for_match.push(obj)
    end
    terms_for_match
  end

  # 参数处理
  def set_query_params
    params.permit(:query, :type, :returnSize)
  end
end