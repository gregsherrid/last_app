require 'spec_helper'

describe "AuthenticationPages" do

	subject { page }

	describe "signin page" do
		before { visit signin_path }

		is_signin_page
		it { should have_selector( 'title', text: 'Sign in') }

		describe "with invalid information" do
			before { click_button "Sign in" }

			is_signin_page
			it { should have_selector( 'div.alert.alert-error', text: "Invalid" ) }

			it { should have_link( 'sample app', href: root_path ) }
			it { should_not have_link( 'Users', href: users_path ) }
			it { should_not have_link( 'Profile' ) }
			it { should_not have_link( 'Settings' ) }
			it { should_not have_link( 'Sign out', href: signout_path ) }
			it { should have_link( 'Sign in', href: signin_path ) }


			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector( 'div.alert.alert-error' ) }
			end

		end

		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before { sign_in user }

			#All signed in display. Hereafter, we test
			#for presence of either signout or signin
			it { should have_link( 'sample app', href: root_path ) }
			it { should have_selector( 'title', text: user.name ) }
			it { should have_link( 'Users', href: users_path ) }
			it { should have_link( 'Settings',  ) }
			it { should have_link( 'Profile', href: user_path(user) ) }
			it { should have_link( 'Sign out', href: signout_path ) }
			it { should_not have_link( 'Sign in', href: signin_path ) }

			describe "followed by signout" do
				before { click_link "Sign out" }
				is_signed_out
			end
		end
	end

	describe "authorization" do

		describe "for non-signed-in users" do
			let(:user) { FactoryGirl.create(:user) }

			describe "in the Users controller" do

				describe "when attempting to visit a protected page" do
					before do
						visit edit_user_path(user)
						fill_in "Email", with: user.email
						fill_in "Password", with: user.password
						click_button "Sign in"
					end

					describe "after signing in" do
						is_user_update_page
					end

				end

				describe "visiting the user index" do
					before { visit users_path }
					is_signin_page
				end

				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					is_signin_page
				end

				describe "submitting to the update action" do
					before { put user_path(user) }
					specify { response.should redirect_to(signin_path) }
				end
			end
		end

		describe "as wrong user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create( :user, email: "wrong@example.com") }
			before { sign_in user }

			describe "visiting User#edit page" do
				before { visit edit_user_path(wrong_user) }
				is_index_page
			end

			describe "submitting a PUT request to the Users#update action" do
				before { put user_path(wrong_user) }
				specify { response.should redirect_to(root_path) }
			end
		end

		describe "as non-admin user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_admin) { FactoryGirl.create(:user) }

			before { sign_in non_admin }

			it "should not delete" do
				expect { delete user_path(user) }.to change(User, :count)
			end

			describe "submitting a DELETE request to the Users#destroy action" do
				before { delete user_path(user) }

				specify { response.should redirect_to(root_path ) }
			end
		end
	end
end



