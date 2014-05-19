class ExperienceArticlesController < ApplicationController
  before_action :set_experience_article, only: [:show, :edit, :update, :destroy]

  # GET /experience_articles
  # GET /experience_articles.json
  def index
    @experience_articles = ExperienceArticle.all
  end

  # GET /experience_articles/1
  # GET /experience_articles/1.json
  def show
  end

  # GET /experience_articles/new
  def new
    @experience_article = ExperienceArticle.new
  end

  # GET /experience_articles/1/edit
  def edit
  end

  # POST /experience_articles
  # POST /experience_articles.json
  def create
    @experience_article = current_user.experience_articles.new(experience_article_params)

    respond_to do |format|
      if @experience_article.save
        format.html { redirect_to @experience_article, notice: 'Experience article was successfully created.' }
        format.json { render :show, status: :created, location: @experience_article }
      else
        format.html { render :new }
        format.json { render json: @experience_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /experience_articles/1
  # PATCH/PUT /experience_articles/1.json
  def update
    respond_to do |format|
      if @experience_article.update(experience_article_params)
        format.html { redirect_to @experience_article, notice: 'Experience article was successfully updated.' }
        format.json { render :show, status: :ok, location: @experience_article }
      else
        format.html { render :edit }
        format.json { render json: @experience_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /experience_articles/1
  # DELETE /experience_articles/1.json
  def destroy
    @experience_article.destroy
    respond_to do |format|
      format.html { redirect_to experience_articles_url, notice: 'Experience article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_experience_article
      @experience_article = ExperienceArticle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def experience_article_params
      params.require(:experience_article).permit(:title, :content, :agree_score, :theme_id, :industry_id, :category_id, :mark_flag, :user_id)
    end
end
