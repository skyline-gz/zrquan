class CareerController < ApplicationController
  before_action :set_career, only: [:edit]

  def new
  end

  def create
    @career = current_user.careers.new(career_params)
    is_career_saved = @career.save
    # 更新最新职业信息
    latest = current_user.careers.order("leave_year desc").first
    is_latest_career_updated = true
    if @career.leave_year >= latest.leave_year
      is_latest_career_updated = current_user.update(
          latest_company_name: @career.company.name,
          latest_position: @career.position
      )
    end
    if is_career_saved and is_latest_career_updated
      # TODO 更新成功的json
    else
      # TODO 更新失败的json
    end
  end

  def edit

  end

  def update
    is_career_updated = @career.update(career_params)
    # 更新最新职业信息
    latest = current_user.careers.order("leave_year desc").first
    is_latest_career_updated = true
    if @career.leave_year >= latest.leave_year
      is_latest_career_updated = current_user.update(
          latest_company_name: @career.company.name,
          latest_position: @career.position
      )
    end
    if is_career_updated and is_latest_career_updated
      # TODO 更新成功的json
    else
      # TODO 更新失败的json
    end
  end

  private
    def set_career
      @career = Career.find(params[:id])
    end

    def career_params
      params.require(:career).permit(:company_id, :position, :entry_year, :leave_year, :description)
    end
end
