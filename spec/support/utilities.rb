include ApplicationHelper

###### CHANGES TO THIS FILE REQUIRE RESTARTING SPORK ######


def sign_in(user)
	visit signin_path
	fill_in "Email", with: user.email
	fill_in "Password", with: user.password
	click_button "Sign in"
	  # Sign in when not using Capybara as well.
	cookies[:remember_token] = user.remember_token;
end

######  Methods for quickly testing which page we're on

def has_header( header )
	it { should have_selector( 'h1', text: header ) }
end

def is_index_page() has_header( 'Sample Ap' ) end
def is_about_page() has_header( 'About' ) end
def is_contact_page() has_header( 'Contact' ) end
def is_help_page() has_header( 'Help' ) end
def is_signup_page() has_header( 'Sign up') end

def is_signin_page() has_header( 'Sign in' ) end
def is_signout_page() has_header( 'Sign out' ) end

def is_user_index_page() has_header( 'All users' ) end
def is_profile_page() has_header( 'Profile' ) end
def is_user_update_page() has_header( 'Update your profile' ) end

def is_signed_in
	it { should have_link('Sign out') }
end

def is_signed_out
	it { should have_link('Sign in') }
end
