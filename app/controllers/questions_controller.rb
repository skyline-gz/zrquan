require "date_utils.rb"

class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # 列表
  def index
    # 根据推荐答案的更新时间
    @questions = Question.all.sort_by {|question|
      if question.recommend_answer
        question.recommend_answer.updated_at
      else
        question.updated_at
      end
    }.reverse!
  end

  # 显示
  def show
  end

  # 新建问题对象
  def new
    @question = Question.new
		@question.invitations.build
  end

  # 编辑
  def edit
    authorize! :edit, Question
  end

  # 创建
  def create
    authorize! :answer, Question
		# 创建问题和主题（非严谨，不需事务）
    @question = current_user.questions.new(question_params)
    @question.hot_abs = 3   #问题自身权重
    @question.latest_qa_time = to_yyyymmddhhmmss(Time.now)
    @question.save!
    if question_themes_params != {}
      question_themes_params[:question_themes_attributes][:theme_id].each do |t_id|
        @question_theme = QuestionTheme.new
        @question_theme.question_id = @question.id
        @question_theme.theme_id = t_id
        @question_theme.save!
      end
    end
		# 创建用户行为（发布问题）
		current_user.activities.create!(target_id: @question.id, target_type: "Question", activity_type: 1,
																		publish_date: DateUtils.to_yyyymmdd(Date.today))
		redirect_to @question
  end

  # 更新
  def update
		# 更新问题和主题（非严谨，不需事务）
    @question.update!(question_params)
    if question_themes_params != {}
      question_themes_params[:question_themes_attributes][:theme_id].each do |t_id|
        @question_theme = QuestionTheme.new
        @question_theme.question_id = @question.id
        @question_theme.theme_id = t_id
        @question_theme.save!
      end
    end
		redirect_to @question
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  #def destroy
  #  @question.destroy
  #  respond_to do |format|
  #    format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:title, :content)
    end

    # def invitations_params
    #   params.require(:question).permit(invitations_attributes:[:user_id=>[]])
    # end

    def question_themes_params
      params.require(:question).permit(question_themes_attributes:[:theme_id=>[]])
    end
end
