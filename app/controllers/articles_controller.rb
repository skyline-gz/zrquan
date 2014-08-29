class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy, :agree]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
		@article.output_title
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = current_user.articles.new(article_params)
		if params[:commit] == "Create"
			@article.draft_flag = false
		elsif params[:commit] == "Draft"
			@article.draft_flag = true
		end
		# save
    @article.save!
    redirect_to @article, notice: 'Create article succeed.'
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
		@article.update_attributes!(article_params)
    redirect_to @article, notice: 'Article was successfully updated.'
  end

	def agree
		latest_score = @article.try(:agree_score) || 0
		# agree from mentor plus 2 and agree from normal user plus 1
		if current_user.mentor_flag
			latest_score = latest_score + 2
			@article.update_attributes!(:agree_score => latest_score)
		else
			latest_score = latest_score + 1
			@article.update_attributes!(:agree_score => latest_score)
		end
		if @article.user.user_setting.aggred_flag
			msg_content = current_user.email + " agreed your article for " + @article.title + "."
			@article.user.messages.create!(content: msg_content, msg_type: 1)
		end
		# create activity
		current_user.activities.create!(target_id: @article.id, target_type: "Article", activity_type: 6,
																		title: @article.title, content: @article.content, publish_date: today_to_i, 
																		theme:@article.theme, recent_flag: true)
	  redirect_to @article, notice: 'Answer was successfully updated.'
	end

  # DELETE /articles/1
  # DELETE /articles/1.json
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
