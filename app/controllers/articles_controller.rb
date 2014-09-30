class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy, :agree]

  # 列表
  def index
    @articles = Article.all
  end

  # 显示经验
  def show
		@article.output_title
  end

  # 新建经验对象
  def new
    @article = Article.new
  end

  # 编辑
  def edit
  end

  # 创建
  def create
		# 创建经验
    @article = current_user.articles.new(article_params)
		if params[:commit] == "Create"
			@article.draft_flag = false
		elsif params[:commit] == "Draft"
			@article.draft_flag = true
		end
    @article.save!
    redirect_to @article, notice: 'Create article succeed.'
  end

  # 更新
  def update
	  # 更新经验
		@article.update!(article_params)
    redirect_to @article, notice: 'Article was successfully updated.'
  end

	# 赞同
	def agree
		latest_score = @article.try(:agree_score) || 0
		# 更新赞同分数（导师+2，普通用户+1）
		if current_user.mentor_flag
			latest_score = latest_score + 2
			@article.update!(:agree_score => latest_score)
		else
			latest_score = latest_score + 1
			@article.update!(:agree_score => latest_score)
		end
		# 创建消息，发送给用户
		if @article.user.user_setting.aggred_flag
			msg_content = current_user.email + " agreed your article for " + @article.title + "."
			@article.user.messages.create!(content: msg_content, msg_type: 1)
		end
		# 创建用户赞同信息
		current_user.agreements.create!(agreeable_id: @article.id, agreeable_type: "Article")
		# 创建用户行为（赞同经验）
		current_user.activities.create!(target_id: @article.id, target_type: "Article", activity_type: 6,
																		title: @article.title, content: @article.content, publish_date: DateUtils.to_yyyymmdd(Date.today), 
																		theme:@article.theme, recent_flag: true)
	  redirect_to @article, notice: 'Answer was successfully updated.'
	end

  # 删除（只限草稿）
  def destroy
    @article.destroy
    redirect_to articles_url, notice: 'Article was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :content, :agree_score, :theme_id, :industry_id, :category_id, :mark_flag, :user_id)
    end		
end
