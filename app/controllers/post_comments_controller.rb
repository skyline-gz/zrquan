class PostCommentsController < ApplicationController
  before_action :set_post_comment, only: [:agree, :cancel_agree, :oppose, :cancel_oppose]
  before_action :set_post, only: [:create, :agree, :cancel_agree, :oppose, :cancel_oppose]

  # GET /post_comments
  # GET /post_comments.json
  def index
    @post_comments = PostComment.all
  end

  # GET /post_comments/new
  def new
    @post_comment = PostComment.new
  end

  # POST /post_comments
  # POST /post_comments.json
  def create
    # 写评论
    @post_comment = current_user.post_comments.new(post_comment_params)
    @post_comment.post_id = @post.id
    is_post_comment_saved = @post_comment.save
    # 更新post
    new_weight = @post.weight + 1
    if @post.hottest_comment_id != nil
      is_post_updated = @post.update(
          weight: new_weight,
          comment_count: @post.comment_count + 1,
          hot: RankingUtils.post_hot(new_weight, @post.epoch_time)
      )
    else
      is_post_updated = @post.update(
          weight: new_weight,
          comment_count: @post.comment_count + 1,
          hottest_comment_id: @post_comment.id,
          hot: RankingUtils.post_hot(new_weight, @post.epoch_time)
      )
    end

    is_activities_saved = save_activities(@post_comment.id, "PostComment", @post.id, "Post", 4)

    if is_post_comment_saved and is_post_updated and is_activities_saved
      # TODO 成功的json
      redirect_to :controller => 'posts',:action => 'show', :id => @post.token_id
    else
      render :json => {:code => ReturnCode::FA_WRITING_TO_DATABASE_ERROR}
    end
  end

  # 赞同
  def agree
    if can? :agree, @post_comment
      # 成功赞成
      agreement = current_user.agreements.new(
          agreeable_id: @post_comment.id, agreeable_type: "PostComment")
      is_agreement_saved = agreement.save
      # 取消反对
      cancel_result = Opposition.where(
          "opposable_id = ? and opposable_type = ? and user_id = ?",
          @post_comment.id, "PostComment", current_user.id
      ).destroy_all

      # 更新投票及排名因子
      agree_score = @post_comment.agree_score + 1
      actual_score = @post_comment.actual_score + 1
      is_post_comment_updated = @post_comment.update(
          agree_score: agree_score,
          actual_score: actual_score
      )

      # 更新本体相关信息
      to_update_hottest_id = get_to_update_hottest(actual_score)
      new_weight = @post.weight + 1
      comment_agree = @post.comment_agree + 1
      hot = RankingUtils.post_hot(new_weight, @post.epoch_time)
      is_post_updated = agree_update_post(new_weight, hot, comment_agree, to_update_hottest_id)

      # 更新post_theme
      PostTheme.where("post_id = ?", @post.id).update_all(hot: hot)

      if cancel_result > 0 and is_agreement_saved and
          is_post_comment_updated and is_post_updated
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
    if can? :cancel_agree, @post_comment
      # 成功取消
      cancel_result = Agreement.where(
          "agreeable_id = ? and agreeable_type = ? and user_id = ?",
          @post_comment.id, "PostComment", current_user.id
      ).destroy_all

      # 更新投票
      agree_score = @post_comment.agree_score - 1
      actual_score = @post_comment.actual_score - 1
      is_post_comment_updated = @post_comment.update(
          agree_score: agree_score,
          actual_score: actual_score
      )

      # 更新本体相关信息
      to_update_hottest_id = get_to_update_hottest(actual_score)
      new_weight = @post.weight - 1
      comment_agree = @post.comment_agree - 1
      hot = RankingUtils.post_hot(new_weight, @post.epoch_time)
      is_post_updated = agree_update_post(new_weight, hot, comment_agree, to_update_hottest_id)

      # 更新post_theme
      PostTheme.where("post_id = ?", @post.id).update_all(hot: hot)

      if cancel_result > 0 and is_post_comment_updated and is_post_updated
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
    if can? :oppose, @post_comment
      # 成功反对
      opposition = current_user.oppositions.new(
          opposable_id: @post_comment.id, opposable_type: "PostComment")
      is_opposition_saved = opposition.save
      # 取消赞成
      cancel_result = Agreement.where(
          "agreeable_id = ? and agreeable_type = ? and user_id = ?",
          @post_comment.id, "PostComment", current_user.id
      ).destroy_all

      # 更新投票及排名因子
      oppose_score = @post_comment.oppose_score + 1
      actual_score = @post_comment.actual_score - 1
      is_post_comment_updated = @post_comment.update(
          oppose_score: oppose_score,
          actual_score: actual_score
      )

      # 更新本体相关信息
      to_update_hottest_id = get_to_update_hottest(actual_score)
      new_weight = @post.weight - 1
      hot = RankingUtils.post_hot(new_weight, @post.epoch_time)
      oppose_update_post(new_weight, hot, to_update_hottest_id)

      # 更新post_theme
      PostTheme.where("post_id = ?", @post.id).update_all(hot: hot)

      if cancel_result > 0 and is_opposition_saved and is_post_comment_updated and is_post_updated
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
    if can? :cancel_oppose, @post_comment
      # 成功取消
      cancel_result = Opposition.where(
          "opposable_id = ? and opposable_type = ? and user_id = ?",
          @post_comment.id, "PostComment", current_user.id
      ).destroy_all

      # 更新投票及排名因子
      oppose_score = @post_comment.oppose_score - 1
      actual_score = @post_comment.actual_score + 1
      is_post_comment_updated = @post_comment.update(
          oppose_score: oppose_score,
          actual_score: actual_score
      )

      # 更新本体相关信息
      to_update_hottest_id = get_to_update_hottest(actual_score)
      new_weight = @post.weight + 1
      hot = RankingUtils.post_hot(new_weight, @post.epoch_time)
      oppose_update_post(new_weight, hot, to_update_hottest_id)

      # 更新post_theme
      PostTheme.where("post_id = ?", @post.id).update_all(hot: hot)

      if cancel_result > 0 and is_post_comment_updated and is_post_updated
        render :json => { :code => ReturnCode::S_OK }
      else
        render :json => { :code => ReturnCode::FA_WRITING_TO_DATABASE_ERROR }
      end
    else
      render :json => { :code => ReturnCode::FA_UNAUTHORIZED }
    end
  end

  private
    # 看看是否需要更新question里面的hottest_answer,如果需要返回id
    def get_to_update_hottest(actual_score)
      to_update_hottest_id = nil
      if @post.hottest_comment_id != @post_comment.id
        finished_sql = SqlUtils.escape_sql(PostSql::COMMENT_ID_AND_SCORE, @post.hottest_comment_id)
        hottest_comment = ActiveRecord::Base.connection.select_all(finished_sql)
        score = hottest_comment[0]["score"]
        if actual_score > score
          to_update_hottest_id = @post_comment.id
        end
      end
      to_update_hottest_id
    end

    def agree_update_post(weight, hot, comment_agree, to_update_hottest_id)
      if to_update_hottest_id != nil
        is_post_updated = @post.update(
            weight: weight,
            comment_agree: comment_agree,
            hot: hot,
            hottest_comment_id: to_update_hottest_id
        )
      else
        is_post_updated = @post.update(
            weight: weight,
            comment_agree: comment_agree,
            hot: hot
        )
      end
      is_post_updated
    end

    def oppose_update_post(weight, hot, to_update_hottest_id)
      if to_update_hottest_id != nil
        is_post_updated = @post.update(
            weight: weight,
            hot: hot,
            hottest_comment_id: to_update_hottest_id
        )
      else
        is_post_updated = @post.update(
            weight: weight,
            hot: hot
        )
      end
      is_post_updated
    end

    def save_activities(target_id, target_type, sub_target_id, sub_target_type, activity_type)
      act = current_user.activities.new
      act.target_id = target_id
      act.target_type = target_type
      act.activity_type = activity_type
      act.sub_target_id = sub_target_id
      act.sub_target_type = sub_target_type
      act.publish_date = DateUtils.to_yyyymmdd(Date.today)
      act.save
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_post_comment
      @post_comment = PostComment.find(params[:id])
    end

    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_comment_params
      params.require(:post_comment).permit(:content, :agree_score, :oppose_score, :anonymous_flag, :post_id, :user_id, :replied_comment_id)
    end
end
