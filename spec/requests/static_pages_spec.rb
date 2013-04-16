require 'spec_helper'

describe "Static pages" do

    subject { page }

    shared_examples_for "all static pages" do
        it { should have_selector( 'title', text: full_title( page_title ) ) }
    end

    describe "Home page" do
        before { visit root_path }
        let (:page_title) { '' }

        it_should_behave_like "all static pages"

        is_index_page

        it { should_not have_selector('title', :text => "| Home" ) }

        describe "for signed-in users" do
            let( :user ) { FactoryGirl.create(:user) }
            before do
                FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
                FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
                sign_in user
                visit root_path
            end

            it "should render the user's feed" do
                user.feed.each do |item|
                    page.should have_selector("li##{item.id}", text: item.content )
                end
            end

            describe "follower/following counts" do
                let(:other_user) { FactoryGirl.create(:user) }
                before do
                    other_user.follow!(user)
                    visit root_path
                end

                it { should have_link("0 following", href: following_user_path(user)) }
                it { should have_link("1 followers", href: followers_user_path(user)) }

            end
        end
    end

    describe "Contact page" do
        before { visit contact_path }
        let (:page_title) { 'Contact' }
        it_should_behave_like "all static pages"

        is_contact_page
    end


    describe "Help page" do
        before { visit help_path }
        let (:page_title) { 'Help' }
        it_should_behave_like "all static pages"

        is_help_page
    end

    describe "About page" do
        before { visit about_path }
        let (:page_title) { 'About' }
        it_should_behave_like "all static pages"

        is_about_page
    end

    describe "correct layout links" do
        before do
            visit root_path
            click_link "About"
        end

        is_about_page

        describe "to help" do
            before { click_link "Help" }

            is_help_page

            describe "to contact" do
                before { click_link "Contact" }

                is_contact_page

                describe "to signup" do
                    before do
                        click_link "Home"
                        click_link "Sign up now!"
                    end

                    is_signup_page

                    describe "back to index" do
                        before { click_link "sample ap" }

                        is_index_page
                    end
                end
            end
        end
    end
end




