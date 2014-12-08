require 'returncode_define'

class ThemesController < ApplicationController
  include AutomatchUtils

  before_action :set_theme_params
  SUPPORT_TYPE = %w('Company', 'School', 'Skill', 'Certification', 'OtherWiki')

  def create
    name = params[:name]
    description = params[:description]
    theme_type = params[:theme_type]
    code = nil
    if name == nil || name.length <= 0 || theme_type == nil
      render :json => {:code => ReturnCode::FA_INVALID_PARAMETERS}
      return
    end

    if SUPPORT_TYPE.find { |e| /#{theme_type}/ =~ e }
      # 检验是否有重名(利用unique制约触发save的结果判断)
      begin
        theme_related_obj = theme_type.constantize.new(:name=>name, :description => description)
        if theme_related_obj.save
          # 更新自动匹配相关的缓存
          if support_match(theme_type)
            add_term(theme_related_obj, theme_type)
          end
          @theme = Theme.new(:name => theme_related_obj.name, \
                            :substance_id => theme_related_obj.id, :substance_type => theme_type)
          if @theme.save
            add_term(@theme, 'Theme')
            render :json => {:code => ReturnCode::S_OK, :data => @theme} and return
          end
          raise
        else
          raise
        end
      rescue Exception
        code = ReturnCode::FA_TERM_ALREADY_EXIT
      end
      render :json => {:code => code}
    else
      render :json => {:code => ReturnCode::FA_NOT_SUPPORTED_PARAMETERS}
    end
  end

  # 参数处理
  def set_theme_params
    params.permit(:name, :description, :theme_type)
  end
end