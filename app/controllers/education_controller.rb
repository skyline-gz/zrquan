class EducationController < ApplicationController
  before_action :set_education, only: [:edit]

  def new
  end

  def create
    @education = current_user.educations.new(education_params)
    is_education_saved = @education.save
    # 更新最新教育信息
    latest = current_user.educations.order("graduate_year desc").first
    is_latest_edu_updated = true
    if @education.graduate_year >= latest.graduate_year
      is_latest_edu_updated = current_user.update(
          latest_school_name: @education.school.name,
          latest_major: @education.major
      )
    end
    if is_education_saved and is_latest_edu_updated
      # TODO 更新成功的json
    else
      # TODO 更新失败的json
    end
  end

  def edit
  end

  def update
    is_edu_updated = @education.update(education_params)
    # 更新最新教育信息
    latest = current_user.educations.order("graduate_year desc").first
    is_latest_edu_updated = true
    if @education.graduate_year >= latest.graduate_year
      is_latest_edu_updated = current_user.update(
          latest_school_name: @education.school.name,
          latest_major: @education.major
      )
    end
    if is_edu_updated and is_latest_edu_updated
      # TODO 更新成功的json
    else
      # TODO 更新失败的json
    end
  end

  private
  def set_education
    @education = Education.find(params[:id])
  end

  def education_params
    params.require(:education).permit(:school_id, :major, :graduate_year, :description)
  end
end
