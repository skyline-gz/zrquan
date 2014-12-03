require 'returncode_define'

class ThemesController < ApplicationController
  before_action :set_theme_params
  SUPPORT_TYPE = %w('Company', 'School', 'Skill', 'Certification', 'OtherWiki')

  def create
    name = params[:name]
    description = params[:description]
    theme_type = params[:theme_type]
    if name == nil || name.length <= 0 || theme_type == nil
      render :json => {:code => ReturnCode::FA_INVALID_PARAMETERS}
      return
    end

    if SUPPORT_TYPE.find { |e| /#{theme_type}/ =~ e }
      ActiveRecord::Base.transaction do
        theme_related_obj = nil
        case theme_type
          when 'Company'
            theme_related_obj = Company.create!(:name=>name, :description => description)
          when 'School'
            theme_related_obj = School.create!(:name=>name, :description => description)
          when 'Skill'
            theme_related_obj = Skill.create!(:name=>name, :description => description)
          when 'Certification'
            theme_related_obj = Certification.create!(:name=>name, :description => description)
          when 'OtherWiki'
            theme_related_obj = OtherWiki.create!(:name=>name, :description => description)
          else
        end
        @theme = theme_related_obj.themes.create!(:name => theme_related_obj.name, \
          :substance_id => theme_related_obj.id, :substance_type => theme_type)
      end
      render :json => {:code => ReturnCode::S_OK}
    else
      render :json => {:code => ReturnCode::FA_NOT_SUPPORTED_PARAMETERS}
    end
  end

  # 参数处理
  def set_theme_params
    params.permit(:name, :description, :theme_type)
  end
end