require "rails_helper"
require 'support/controller_macros'
include ControllerMacros

RSpec.describe ApiKeysController, :type => :controller do

  login_user

  it "should have a current_user" do
    # note the fact that I removed the "validate_session" parameter if this was a scaffold-generated controller
    expect(subject.current_user).not_to be_nil
  end
  it "create a correct api" do
    post :create, api_key: FactoryGirl.attributes_for(:api_key, user_id: subject.current_user.id)
    expect(response).to render_template(:show)
    expect(response).to have_http_status(302)
    expect(response).not_to have_http_status(422)
  end
  it "loads apikey into index" do
    apik1 = ApiKey.create!(FactoryGirl.attributes_for(:api_key, user_id: subject.current_user.id))
    get :index

    expect(assigns(:api_keys)).to match_array([apik1])
  end
end

