require 'return_code'
require 'date_utils.rb'

class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :follow, :un_follow]
  before_action :authenticate_user!

  DEFAULT_SHOW_LENGTH = 20
  PULL_TO_REFRESH_LENGTH = 10
  QUESTION_LIST_TYPE = {:NEWEST => 1, :HOTTEST => 2, :NOT_ANSWERED => 3}

  # 列表 type:int ,1 最新, 2 最热， 3未回答
  def index
    type = params[:type] || QUESTION_LIST_TYPE[:NEWEST]
    @questions = get_questions_by_type type.to_i
    # 显示前20条
    @questions = @questions[0..DEFAULT_SHOW_LENGTH - 1]
  end

  # 列出 type:int ,1 最新, 2 最热， 3未回答, last_id 最后一条的记录，第一条记录将从此id的后面开始取
  def list
    type = params[:type] || QUESTION_LIST_TYPE[:NEWEST]
    last_id = params[:last_id]
    @questions = get_questions_by_type type.to_i
    start = 0
    if last_id
      @questions.each_with_index {|q, i|
        if q.token_id == last_id.to_i
          start = i
          next
        end
      }
    end
    # 加载10条
    @questions = @questions[(start + 1)..(start + PULL_TO_REFRESH_LENGTH)]
    render 'questions/list'
  end

  # 显示
  def show
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
    # 创建问题
    @question = current_user.questions.new(question_params)
    @question.hot_abs = 3 #问题自身权重
    current_time = Time.now
    @question.latest_qa_time = DateUtils.to_yyyymmddhhmmss(current_time)
    @question.created_at = current_time
    @question.edited_at = current_time
    @question.updated_at = current_time
    @question.save!
    # 创建问题主题关联
    if params[:question][:themes] != nil
      themes = params[:question][:themes].split(',').map { |s| s.to_i }
      themes.each do |t_id|
        @question_theme = @question.question_themes.new
        @question_theme.theme_id = t_id
        @question_theme.save!
      end
    end
    # 提问者自动关注当前问题
    @question.question_follows.create(user_id: current_user.id)
    # 创建用户行为（发布问题）
    current_user.activities.create!(target_id: @question.id, target_type: "Question", activity_type: 1,
                                    publish_date: DateUtils.to_yyyymmdd(Date.today))
    redirect_to action: 'show', id: @question.token_id
  end

  # 更新
  def update
    # 更新问题和主题（非严谨，不需事务）
    @question.edited_at = Time.now
    @question.update(question_params)
    if params[:question][:themes] != nil
      themes = params[:question][:themes].split(',').map { |s| s.to_i }
      # 清空之前的主题-问题关联
      # Todo:可以考虑增量更新，减少SQL插入量
      @question.question_themes.each do |question_theme|
        question_theme.destroy;
      end
      themes.each do |t_id|
        @question_theme = @question.question_themes.new
        @question_theme.theme_id = t_id
        @question_theme.save!
      end
    end
    redirect_to action: 'show', id: @question.token_id
  end

  # 关注
  def follow
    if can? :follow, @question
      @question.question_follows.create(user_id: current_user.id)
      render :json => { :code => ReturnCode::S_OK }
    else
      render :json => { :code => ReturnCode::FA_RESOURCE_ALREADY_EXIST }
    end
  end

  # 取消关注
  def un_follow
    if can? :un_follow, @question
      QuestionFollow.find_by(user_id: current_user.id, question_id: @question.id).destroy
      render :json => { :code => ReturnCode::S_OK }
    else
      render :json => { :code => ReturnCode::FA_RESOURCE_NOT_EXIST }
    end
  end

  # 转成匿名
  def to_anonymous
    @question.update(anonymous_flag: true)
    to_anonymous_comments
  end

  # 转成实名
  def to_real_name

  end

  private
    def to_anonymous_comments
      Comment.connection.execute(
          "update COMMENTS c
           set ANONYMOUS_FLAG = 1
           where
           c.commentable_id = #{@question.id} and
           c.commentable_type = 'Question' ")
      Comment.connection.execute(
          "update COMMENTS c
           inner join ANSWERS a on (c.commentable_id = a.id and a.question_id = #{@question.id})
           set ANONYMOUS_FLAG = 1
           where c.commentable_type = 'Answer' ")
    end

    def set_question
      @question = Question.find_by_token_id(params[:id])
    end

    def get_questions_by_type(type)
      case type
        when QUESTION_LIST_TYPE[:NEWEST]
          # 根据最近回答的时间排序
          Question.all.sort_by { |q| q.latest_qa_time }.reverse!
        when QUESTION_LIST_TYPE[:HOTTEST]
          Question.all.sort_by { |q| q.hot_abs.to_f / ((((Time.now - q.created_at)/ 1.hour).round) + 12) }.reverse!
        when QUESTION_LIST_TYPE[:NOT_ANSWERED]
          Question.all.select { |q| q.latest_answer_id == nil }.sort_by { |q| q.latest_qa_time }.reverse!
        else
          [];
      end
    end

    def question_params
      params.require(:question).permit(:title, :content)
    end
end
