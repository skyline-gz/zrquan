class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

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

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def agree
    if can? :agree, @post
      @agreement = current_user.agreements.new(
          agreeable_id: @post.id, agreeable_type: "Post")
      # 成功赞成
      if @agreement.save
        # 更新赞同分数（因为职人的范围变广，所有人都+1）
        @post.update!(agree_score: @post.agree_score + 1)
        @post.update!(hot_abs: @post.hot_abs + 1)
        # 创建赞同答案的消息并发送
        MessagesAdapter.perform_async(MessagesAdapter::ACTION_TYPE[:USER_AGREE_ANSWER], current_user.id, @post.id)
        # 创建用户行为（赞同答案）
        current_user.activities.create!(target_id: @post.id, target_type: "Post", activity_type: 5,
                                        publish_date: DateUtils.to_yyyymmdd(Date.today))
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
      result = Agreement.where(
          "agreeable_id = ? and agreeable_type = ?", @post.id, "Post"
      ).destroy_all
      # 成功取消
      if result > 0
        # 更新赞同分数（因为职人的范围变广，所有人都+1）
        @post.update!(agree_score: @post.agree_score - 1)
        @post.update!(hot_abs: @post.hot_abs - 1)
        render :json => { :code => ReturnCode::S_OK }
      else
        render :json => { :code => ReturnCode::FA_WRITING_TO_DATABASE_ERROR }
      end
    else
      render :json => { :code => ReturnCode::FA_UNAUTHORIZED }
    end
  end

  def oppose
    if can? :oppose, @post
      @opposition = current_user.oppositions.new(
          opposable_id: @post.id, opposable_type: "Post")
      # 成功反对
      if @opposition.save
        # 更新排名因子
        @post.update!(hot_abs: @post.hot_abs - 1)
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
      result = Opposition.where(
          "opposable_id = ? and opposable_type = ?", @post.id, "Post"
      ).destroy_all
      # 成功取消
      if result > 0
        # 更新排名因子
        @post.update!(hot_abs: @post.hot_abs + 1)
        render :json => { :code => ReturnCode::S_OK }
      else
        render :json => { :code => ReturnCode::FA_WRITING_TO_DATABASE_ERROR }
      end
    else
      render :json => { :code => ReturnCode::FA_UNAUTHORIZED }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:token_id, :content, :agree_score, :oppose_score, :anonymous_flag, :user_id, :edited_at)
    end
end
