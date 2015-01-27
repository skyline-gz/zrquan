require 'ranking_utils.rb'

class PostsController < ApplicationController
  before_action :set_post, only: [:show, :agree, :cancel_agree, :oppose, :cancel_oppose]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.new(post_params)
    @post.weight = 1 #本体自身权重
    @post.epoch_time = Time.now.to_i
    @post.hot = RankingUtils.post_hot(@post.weight, @post.epoch_time)
    @post.publish_date = DateUtils.to_yyyymmdd(Date.today)
    is_post_saved = @post.save
    # 创建问题主题关联
    is_post_theme_saved = save_post_theme
    # 创建用户行为（发布问题）
    is_activities_saved = save_activities(@post.id, "Post", 1)

    if is_post_saved and is_post_theme_saved and is_activities_saved
      redirect_to action: 'show', id: @post.token_id
      # TODO 成功的json
    else
      # TODO 失败的json
    end
  end

  def agree
    if can? :agree, @post
      # 成功赞成
      agreement = current_user.agreements.new(
          agreeable_id: @post.id, agreeable_type: "Post")
      is_agreement_saved = agreement.save
      # 更新post
      new_weight = @post.weight + 1
      is_post_updated = @post.update(
          agree_score: @post.agree_score + 1,
          weight: new_weight,
          hot: RankingUtils.post_hot(new_weight, @post.epoch_time)
      )
      # 创建赞同答案的消息并发送
      MessagesAdapter.perform_async(MessagesAdapter::ACTION_TYPE[:USER_AGREE_ANSWER], current_user.id, @post.id)
      # 创建用户行为（赞同）
      is_activities_saved = save_activities(@post.id, "Post", 5)

      if is_agreement_saved and is_post_updated and is_activities_saved
        render :json => { :code => ReturnCode::S_OK }
      else
        render :json => { :code => ReturnCode::FA_WRITING_TO_DATABASE_ERROR }
      end
    else
      render :json => { :code => ReturnCode::FA_UNAUTHORIZED }
    end
  end

  # 取消赞同
  def cancel_agree
    if can? :cancel_agree, @post
      # 成功取消
      cancel_result = Agreement.where(
          "agreeable_id = ? and agreeable_type = ? and user_id = ?",
          @post.id, "Post", current_user.id
      ).destroy_all
      # 更新赞同分数（因为职人的范围变广，所有人都+1）
      new_weight = @post.weight - 1
      is_post_updated = @post.update(
          agree_score: @post.agree_score - 1,
          weight: new_weight,
          hot: RankingUtils.post_hot(new_weight, @post.epoch_time)
      )
      if cancel_result > 0 and is_post_updated
        render :json => { :code => ReturnCode::S_OK }
      else
        render :json => { :code => ReturnCode::FA_WRITING_TO_DATABASE_ERROR }
      end
    else
      render :json => { :code => ReturnCode::FA_UNAUTHORIZED }
    end
  end

  # 反对
  def oppose
    if can? :oppose, @post
      # 成功反对
      @opposition = current_user.oppositions.new(
          opposable_id: @post.id, opposable_type: "Post")
      is_opposition_saved = @opposition.save
      # 更新排名因子
      new_weight = @post.weight - 1
      is_post_updated = @post.update(
          oppose_score: @post.oppose_score + 1,
          weight: new_weight,
          hot: RankingUtils.post_hot(new_weight, @post.epoch_time)
      )
      if is_opposition_saved and is_post_updated
        render :json => { :code => ReturnCode::S_OK }
      else
        render :json => { :code => ReturnCode::FA_WRITING_TO_DATABASE_ERROR }
      end
    else
      render :json => { :code => ReturnCode::FA_UNAUTHORIZED }
    end
  end

  # 取消反对
  def cancel_oppose
    if can? :cancel_oppose, @post
      # 成功取消
      cancel_result = Opposition.where(
          "opposable_id = ? and opposable_type = ? and user_id = ?",
          @post.id, "Post", current_user.id
      ).destroy_all
      # 更新排名因子
      new_weight = @post.weight + 1
      is_post_updated = @post.update(
          oppose_score: @post.oppose_score - 1,
          weight: new_weight,
          hot: RankingUtils.post_hot(new_weight, @post.epoch_time)
      )
      if cancel_result > 0 and is_post_updated
        render :json => { :code => ReturnCode::S_OK }
      else
        render :json => { :code => ReturnCode::FA_WRITING_TO_DATABASE_ERROR }
      end
    else
      render :json => { :code => ReturnCode::FA_UNAUTHORIZED }
    end
  end

  # 所有【转匿名】和【转实名】都在一级内容的【更多操作】进行
  # 转成匿名
  def to_anonymous
    if @post.user_id == current_user.id
      @post.update(anonymous_flag: true)
    end
    to_anonymous_comments
  end

  # 转成实名
  def to_real_name
    if @post.user_id == current_user.id
      @post.update(anonymous_flag: false)
    end
    to_real_name_comments
  end

  private
    def save_activities(target_id, target_type, activity_type)
      act = current_user.activities.new
      act.target_id = target_id
      act.target_type = target_type
      act.activity_type = activity_type
      act.publish_date = DateUtils.to_yyyymmdd(Date.today)
      act.save
    end

    def save_post_theme
      is_ok = true
      themes = params[:post][:themes].split(',').map { |s| s.to_i }
      themes.each do |t_id|
        pt = @post.post_themes.new
        pt.theme_id = t_id
        if !pt.save
          is_ok = false
        end
      end
      is_ok
    end

    def to_anonymous_comments
      PostComment.where("post_id = ? and user_id = ?", @post.id, current_user.id).
          update_all(anonymous_flag: true)
    end

    def to_real_name_comments
      PostComment.where("post_id = ? and user_id = ?", @post.id, current_user.id).
          update_all(anonymous_flag: false)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:token_id, :content, :anonymous_flag, :user_id, :edited_at)
    end
end
