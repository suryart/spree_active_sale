require 'spec_helper'

describe Spree::HomeController do
  let(:active_sale_event) { FactoryGirl.create(:active_sale_event) }

  describe 'Get #index method' do
    # it 'shows all active events running', :js => true do
    #   visit '/'
    #   page.should have_content(active_sale_event.name)
    # end

    # describe 'blog post page' do
    #   it 'lets the user post a comment', :js => true do
    #     visit root_path #(blog_posts(:first_post).id)
    #     # fill_in 'Author', :with => 'J. Random Hacker'
    #     # fill_in 'Comment', :with => 'Awesome post!'
    #     # click_on 'Submit'  # this be an Ajax button -- requires Selenium
    #     page.should have_content('has been submitted')
    #     page.should have_content('Awesome post!')
    #   end
    # end
  end
end