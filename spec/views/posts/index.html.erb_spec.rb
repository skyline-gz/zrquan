require 'rails_helper'

RSpec.describe "posts/index", :type => :view do
  before(:each) do
    assign(:posts, [
      Post.create!(
        :token_id => 1,
        :content => "MyText",
        :agree_score => 2,
        :oppose_score => 3,
        :anonymous_flag => false,
        :user => nil
      ),
      Post.create!(
        :token_id => 1,
        :content => "MyText",
        :agree_score => 2,
        :oppose_score => 3,
        :anonymous_flag => false,
        :user => nil
      )
    ])
  end

  it "renders a list of posts" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
