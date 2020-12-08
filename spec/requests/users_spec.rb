require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "#index" do
    context 'when user is signned in' do
      subject(:visit_users) { get users_path }

      let(:user) { create(:user, activated: true, activated_at: Time.zone.now) }

      it 'retunrs a 200 response' do
        sign_in_as(user)
        visit_users
        expect(response).to have_http_status(:ok)
      end

      it 'render index template' do
        sign_in_as(user)
        expect(visit_users).to render_template(:index)
      end
    end

    context 'when user is not signned in' do
      subject(:visit_users) { get users_path }

      it 'retunrs a 302 response' do
        visit_users
        expect(response).to have_http_status(:found)
      end

      it 'render index template' do
        expect(visit_users).to redirect_to(login_url)
      end
    end
  end

  describe "#edit" do
    context 'when user is signned in' do
      subject(:visit_edit_user_page) { get edit_user_path(user) }

      let(:user) { create(:user, activated: true, activated_at: Time.zone.now) }

      it 'retunrs a 200 response' do
        sign_in_as(user)
        visit_edit_user_page
        expect(response).to have_http_status(:ok)
      end

      it 'render edit template' do
        sign_in_as(user)
        expect(visit_edit_user_page).to render_template(:edit)
      end
    end

    context 'when user is not signned in' do
      subject(:visit_edit_user_page) { get edit_user_path(user) }

      let(:user) { create(:user, activated: true, activated_at: Time.zone.now) }

      it 'returns a 302 response' do
        visit_edit_user_page
        expect(response).to have_http_status(:found)
      end

      it 'render index template' do
        expect(visit_edit_user_page).to redirect_to(login_url)
      end
    end
  end

  describe '#show' do
    before do
      user = create(:user, activated: true, activated_at: Time.zone.now)
      @micropost = create(:micropost, user_id: user.id, content: "test1")
    end

    subject { get users_path(user) }

    it 'get user success' do
      sign_in_as(user)

      subject

      expect(response).to have_http_status(:ok)
      expect(user.microposts.reload.size).to eq(1)
    end
  end

  describe '#create' do
    let(:user_params) { 
      {
        name: "test_name",
        email: "test_email@126.com",
        password: "test123456"
      }
    }
    let(:invalid_user_params) {
      {
        name: "test_name",
        password: "test123456"
      }
    }

    it 'save user' do
      post users_path, params: { user: user_params }
      expect(flash[:info]).to eq("Please check your email to activate your account.")
      expect(response).to have_http_status(:found)
    end

    it 'render new' do
      post users_path, params: { user: invalid_user_params }
      expect(response).to render_template :new
    end
  end

  describe '#destroy' do
    let(:test_user) { create(:user, activated: true, activated_at: Time.zone.now) }
    let(:admin_user) { create(:user, activated: true, admin: true, activated_at: Time.zone.now) }

    it 'redirect to login ' do
      delete user_path(test_user)
      expect(response).to redirect_to login_path
    end

    it 'redirect to root_path ' do
      sign_in_as(test_user)
      delete user_path(test_user)
      expect(response).to redirect_to root_path
    end

    it 'return success' do
      sign_in_as(admin_user)
      delete user_path(test_user)
      expect(flash[:success]).to eq("User deleted")
      expect(subject).to redirect_to users_url
    end
  end

  describe '#following' do
    let(:user) { create(:user, activated: true, activated_at: Time.zone.now) }
    let(:user_1) { create(:user, activated: true, activated_at: Time.zone.now) }
    let!(:relationship) { create(:relationship, follower_id: user.id, followed_id: user_1.id) }

    it 'be successful' do
      sign_in_as(user)
      get following_user_path(user)
      expect(assigns(:users).size).to eq(1)
      expect(response).to render_template "show_follow"
    end

  end
  
end
