class CareerController < ApplicationController
  before_action :set_career, only: [:edit]

  def new
  end

  def create
    @career = current_user.careers.new(career_params)
    if @career.save
      # TODO 更新成功的json
    else
      # TODO 更新失败的json
    end
  end

  def edit

  end

  def update
    is_ok = @career.update(career_params)
    if is_ok
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
