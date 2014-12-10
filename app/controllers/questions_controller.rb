require "date_utils.rb"

class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update]
  before_action :authenticate_user!

  # 列表
  def index
    # 根据推荐答案的更新时间
    @questions = Question.all.sort_by { |question|
      if question.recommend_answer
        question.recommend_answer.updated_at
      else
        question.updated_at
      end
    }.reverse!
  end

  # 列出
  def list
    @questions = Question.all
    render 'questions/list.json'
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
    if can? :edit, Question
      @question_themes = @question.question_themes
      render 'questions/edit'
    else
      render :json => {:code => ReturnCode::FA_UNAUTHORIZED}
    end
  end

  # 创建
  def create
    authorize! :answer, Question
    # 创建问题和主题（非严谨，不需事务）
    @question = current_user.questions.new(question_params)
    @question.hot_abs = 3 #问题自身权重
    @question.latest_qa_time = DateUtils.to_yyyymmddhhmmss(Time.now)
    @question.save!
    if params[:question][:themes] != nil
      themes = params[:question][:themes].split(',').map { |s| s.to_i }
      themes.each do |t_id|
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
    if params[:question][:themes] != nil
      themes = params[:question][:themes].split(',').map { |s| s.to_i }
      # 清空之前的主题-问题关联
      # Todo:可以考虑增量更新，减少SQL插入量
      @question.question_themes.each do |question_theme|
        question_theme.destroy;
      end
      themes.each do |t_id|
        @question_theme = QuestionTheme.new
        @question_theme.question_id = @question.id
        @question_theme.theme_id = t_id
        @question_theme.save!
      end
    end
    redirect_to @question
  end

  private
  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :content)
  end
end
