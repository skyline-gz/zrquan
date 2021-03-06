require 'rails_helper'

RSpec.describe "post_comments/show", :type => :view do
  before(:each) do
    @post_comment = assign(:post_comment, PostComment.create!(
      :content => "MyText",
      :agree_score => 1,
      :oppose_score => 2,
      :anonymous_flag => false,
      :post => nil,
      :user => nil,
      :replied_comment => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
