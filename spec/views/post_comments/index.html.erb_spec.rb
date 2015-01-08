require 'rails_helper'

RSpec.describe "post_comments/index", :type => :view do
  before(:each) do
    assign(:post_comments, [
      PostComment.create!(
        :content => "MyText",
        :agree_score => 1,
        :oppose_score => 2,
        :anonymous_flag => false,
        :user => nil,
        :replied_comment => nil
      ),
      PostComment.create!(
        :content => "MyText",
        :agree_score => 1,
        :oppose_score => 2,
        :anonymous_flag => false,
        :user => nil,
        :replied_comment => nil
      )
    ])
  end

  it "renders a list of post_comments" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
