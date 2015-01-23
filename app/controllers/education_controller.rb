class EducationController < ApplicationController
  before_action :set_education, only: [:edit]

  def new
  end

  def create
    @education = current_user.educations.new(education_params)
    if @education.save
      # TODO 更新成功的json
    else
      # TODO 更新失败的json
    end
  end

  def edit
  end

  def update
    is_ok = @education.update(education_params)
    if is_ok
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
