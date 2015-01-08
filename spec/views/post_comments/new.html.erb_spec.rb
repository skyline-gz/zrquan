require 'rails_helper'

RSpec.describe "post_comments/new", :type => :view do
  before(:each) do
    assign(:post_comment, PostComment.new(
      :content => "MyText",
      :agree_score => 1,
      :oppose_score => 1,
      :anonymous_flag => false,
      :user => nil,
      :replied_comment => nil
    ))
  end

  it "renders new post_comment form" do
    render

    assert_select "form[action=?][method=?]", post_comments_path, "post" do

      assert_select "textarea#post_comment_content[name=?]", "post_comment[content]"

      assert_select "input#post_comment_agree_score[name=?]", "post_comment[agree_score]"

      assert_select "input#post_comment_oppose_score[name=?]", "post_comment[oppose_score]"

      assert_select "input#post_comment_anonymous_flag[name=?]", "post_comment[anonymous_flag]"

      assert_select "input#post_comment_user_id[name=?]", "post_comment[user_id]"

      assert_select "input#post_comment_replied_comment_id[name=?]", "post_comment[replied_comment_id]"
    end
  end
end
