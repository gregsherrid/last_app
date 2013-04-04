require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  subject { page }

  describe "Home page" do

    before { visit root_path }
    it { should have_selector( 'h1', text: 'Sample App' ) }
    it { should have_selector('title', text: full_title('') ) }
    it { should_not have_selector('title', :text => "| Home" ) }

  end

  describe "Contact page" do

    before { visit contact_path }
    it "should have the content 'Contact'" do
        page.should have_selector( 'h1', text: 'Contact' )
    end

    it "should have the right title" do
        page.should have_selector('title', :text => "#{base_title} | Contact" )
    end
  end


  describe "Help page" do

    before { visit help_path }
    it "should have the content 'Help'" do
        page.should have_content( 'Help' )
    end

    it "should have the right title" do
        page.should have_selector('title', :text => "#{base_title} | Help" )
    end
  end

  describe "About page" do
    before { visit about_path }
    it "should have the content 'About us'" do
      page.should have_content('About Us')
    end

    it "should have the right title" do
        page.should have_selector('title', :text => "#{base_title} | About Us" )
    end
  end
end
