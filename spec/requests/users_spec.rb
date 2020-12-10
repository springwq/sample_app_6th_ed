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

  describe "#show" do
    context 'when user is signned in' do
      before do
        @user = create(:test_user)
        sign_in_as(@user)
      end
        
      subject { get user_path(id: @user.id) }

      it "retunrs a 200 response" do
        subject
        expect(response).to have_http_status(200)
      end

      it 'render show template' do
        expect(subject).to render_template(:show)
      end
    end
  end

  describe "#create" do
      let(:user_params) { attributes_for(:test_user) }
      
      it "should save user" do
        post users_path, params: { user: user_params }
        expect(response).to redirect_to root_url
      end

      it "should render new" do
        post users_path, params: { user: {name: 'test'} }
        expect(response).to render_template :new
      end
  end

  describe '#destroy' do
    let(:admin) { create(:test_user, admin: true) }
    let(:user) { create(:test_user) }
    
    it 'should return success' do 
      sign_in_as(admin)
      delete user_path(user)
      expect(response).to redirect_to users_url
    end
  end

  describe '#following' do
    let(:users) { create_list(:test_user, 2) }
    let(:relationship) { create(:relationship, follower_id: users.first.id, followed_id: users.last.id) }
    
    it 'should return success' do 
      user = users.first
      sign_in_as(user)
      get following_user_path(user)
      expect(assigns(:users).any?).to eq true
      expect(response).to render_template :show_follow
    end
  end
end
