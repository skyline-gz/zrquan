require 'test_helper'

class ExperienceArticlesControllerTest < ActionController::TestCase
  setup do
    @experience_article = experience_articles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:experience_articles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create experience_article" do
    assert_difference('ExperienceArticle.count') do
      post :create, experience_article: { agree_score: @experience_article.agree_score, category_id: @experience_article.category_id, content: @experience_article.content, industry_id: @experience_article.industry_id, mark_flag: @experience_article.mark_flag, theme_id: @experience_article.theme_id, title: @experience_article.title, user_id: @experience_article.user_id }
    end

    assert_redirected_to experience_article_path(assigns(:experience_article))
  end

  test "should show experience_article" do
    get :show, id: @experience_article
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @experience_article
    assert_response :success
  end

  test "should update experience_article" do
    patch :update, id: @experience_article, experience_article: { agree_score: @experience_article.agree_score, category_id: @experience_article.category_id, content: @experience_article.content, industry_id: @experience_article.industry_id, mark_flag: @experience_article.mark_flag, theme_id: @experience_article.theme_id, title: @experience_article.title, user_id: @experience_article.user_id }
    assert_redirected_to experience_article_path(assigns(:experience_article))
  end

  test "should destroy experience_article" do
    assert_difference('ExperienceArticle.count', -1) do
      delete :destroy, id: @experience_article
    end

    assert_redirected_to experience_articles_path
  end
end
