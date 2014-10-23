require 'rails_helper'

RSpec.describe "photo/search.html.erb", :type => :view do
  pending "add some examples to (or delete) #{__FILE__}"
end

RSpec.describe "photo/index", :type => :view do
  it "renders _event partial for each event" do
    assign(:events, [double(Event), double(Event)])
    render
    expect(view).to render_template(:partial => "_event", :count => 2)
  end
end