require 'return_code'

class AutomatchController < ApplicationController
  include AutomatchUtils

  before_action :authenticate_user!
  before_action :set_query_params


  # 匹配 暂时只实现了字符串单处匹配成功的返回，不支持同时匹配同一字符串的多处子串的返回
  # param: query 'al'
  # 　　　　returnSize 10 可指定返回的记录条数，默认50条记录，最大不超过1000条
  # return: {
  #   code: 'S_OK'  　操作成功
  #   type: 'company' 支持自动匹配的类型，见SUPPORT_TYPE
  #   matches: [] 见如下　返回的最大长度
  #   total: 10  匹配的总长
  #   0: {
  #     value: '阿里巴巴',
  #     ioq: '0', 匹配的优先度，结果默认以此排序，即最前匹配的位置，默认不返回
  #     m_t: 's_py1', 匹配类型，见MATCH_TYPE定义，默认不返回
  #     key: '阿里'
  #     start: 0
  #     length: 2
  #   },
  #   1:
  #     ...
  #   }

  def do_match
    query = params[:query]
    type = params[:type]
    return_size = [params[:returnSize] || 50, 1000].min
    if query == nil|| query.length <= 0 || type == nil
      render :json => {:code => ReturnCode::FA_INVALID_PARAMETERS}
      return
    end
    if support_match type
      results = auto_match(query, type)
      total = results.length
      results = results.slice(0, return_size).each { |k| k.except!(:ioq, :m_t) }
      render :json => {:code => ReturnCode::S_OK, :matches => results, :total => total}
    else
      render :json => {:code => ReturnCode::FA_NOT_SUPPORTED_PARAMETERS}
    end
  end

  private
  def set_query_params
    params.permit(:query, :type, :returnSize)
  end
end