require 'rails_helper'

RSpec.describe "home page", :type => :request do
  fit "displays the user's username after successful login" do
    user = User.create!(:email => "milton@gr33n.com", :password => "password123", :password_confirmation => "password123")
    get "/users/sign_up"
    assert_select "form.new_user" do
      assert_select "input[name=?]", "user[email]"
      assert_select "input[name=?]", "user[password]"
      assert_select "input[name=?]", "user[password_confirmation]"
      assert_select "input[type=?]", "submit"
    end
    post "/users/sign_in", :email => "milton@gr33n.com", :password => "password123"
    get "/api_keys/new"
    assert_select "form.new_api_key" do
      assert_select "input[name=?]", "api_key[api_key]"
    end
    binding.pry
  end
end 