require 'ruby-pinyin'

module AutomatchUtils

  AC_SUPPORT_TYPE = %w('Company', 'School', 'Theme')

  MATCH_ARRAY_PREFIX = 'o_'
  MATCH_TYPE = {
      :value => 's_v',                            #命中原字符串
      :pinyin_value => 's_py',                    #命中字符串的全拼
      :pinyin_value_abbr => 's_py1',              #命中字符串的声母串
      :pinyin_value_abbr_except_lead => 's_py2',  #命中字符串的声母串（原字符串的首个字符不变，仍然是全拼）
  }

  # 判断是否AC_SUPPORT_TYPE中定义的可匹配的类型
  def support_match (type)
    AC_SUPPORT_TYPE.find { |e| /#{type}/ =~ e }
  end

  def auto_match(query, type)
    terms = get_terms(type)
    match_and_sort_terms(terms, query)
  end

  # 当缓存还没过期时，增量更新缓存,term是一个对象，需要有:id 和 :name属性,
  #   type见 AC_SUPPORT_TYPE的定义
  def add_term(term, type)
    terms = TermsCache.instance.read(type)
    if terms
      new_terms = pre_process([term])
      terms = terms.concat new_terms
      TermsCache.instance.write(type, terms)
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
      MATCH_TYPE.each do |k, v|
        match_success = o[v].index(query)
        if match_success
          value = o[MATCH_TYPE[:value]]
          start = length = 0
          if v == MATCH_TYPE[:value]
            start = match_success
            length = query.length
          else
            matched_array = o[MATCH_ARRAY_PREFIX  + MATCH_TYPE[k]]
            pos = calculate_py_position(match_success, query, matched_array)
            if pos == nil
              next
            end
            start = pos[:start]
            length = pos[:length]
          end
          key = value[start..start + length - 1]
          results.push({:id => o[:id], :value => value, \
          :ioq => match_success, :m_t => v, :key=>key, :start => start, :length=>length})
          break
        end
      end
    end

    # 根据最先匹配原则，排序所有结果
    results.sort_by! { |k| k[:ioq] }
  end

  # 当匹配成功的类型是拼音时，计算对应于value的start和length
  def calculate_py_position(matched_index, query, matched_array)
    array_start = start = length = py_start = py_length = 0
    matched_array.each do |v|
      if py_start == matched_index
        break
      end
      if py_start > matched_index
        break
      end
      # 由于'56网'的数组表示为['56','wang']，并非['5','6','wang']，需要调整
      if is_number? v
        start += v.length
      else
        start += 1
      end
      py_start += v.length
      array_start += 1
    end

    if py_start > matched_index
      return nil
    end

    for i in array_start..matched_array.length - 1
      v = matched_array[i]
      py_length += v.length
      if is_number? v
        length += v.length
      else
        length += 1
      end
      if py_length == query.length
        break;
      end
      if py_length > query.length
        break
      end
    end

    {:start => start, :length => length}
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
    terms = pre_process(type.constantize.all)
    TermsCache.instance.write(type, terms)
    terms
  end

  # 拼音预处理
  def pre_process(terms)
    terms_for_match = []
    terms.each do |o|
      name = o.name
      obj = {:id => o.id}
      obj[MATCH_TYPE[:value]] = name
      obj[MATCH_TYPE[:pinyin_value]] = \
        (obj[MATCH_ARRAY_PREFIX + MATCH_TYPE[:pinyin_value]] = PinYin.of_string(name)).join('')
      obj[MATCH_TYPE[:pinyin_value_abbr]] = \
        (obj[MATCH_ARRAY_PREFIX + MATCH_TYPE[:pinyin_value_abbr]] = abbr(name)).join('')
      obj[MATCH_TYPE[:pinyin_value_abbr_except_lead]] =
          (obj[MATCH_ARRAY_PREFIX + MATCH_TYPE[:pinyin_value_abbr_except_lead]] = abbr(name, true)).join('')
      terms_for_match.push(obj)
    end
    terms_for_match
  end

  # overwrite from PINYIN.abbr
  def abbr(str, except_lead=false, except_english=true)
    result = []
    PinYin.of_string(str).each_with_index do |word, i|
      w = (except_lead && i == 0) || (except_english && word.english?) ? word : word[0]
      result.push w
    end
    result
  end

  def is_number?(object)
    true if Float(object) rescue false
  end
end