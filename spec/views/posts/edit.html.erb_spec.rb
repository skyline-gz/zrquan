require 'rails_helper'

RSpec.describe "posts/edit", :type => :view do
  before(:each) do
    @post = assign(:post, Post.create!(
      :token_id => 1,
      :content => "MyText",
      :agree_score => 1,
      :oppose_score => 1,
      :anonymous_flag => false,
      :user => nil
    ))
  end

  it "renders the edit post form" do
    render

    assert_select "form[action=?][method=?]", post_path(@post), "post" do

      assert_select "input#post_token_id[name=?]", "post[token_id]"

      assert_select "textarea#post_content[name=?]", "post[content]"

      assert_select "input#post_agree_score[name=?]", "post[agree_score]"

      assert_select "input#post_oppose_score[name=?]", "post[oppose_score]"

      assert_select "input#post_anonymous_flag[name=?]", "post[anonymous_flag]"

      assert_select "input#post_user_id[name=?]", "post[user_id]"
    end
  end
end
