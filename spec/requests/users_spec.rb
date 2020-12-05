require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "#index" do
    context 'when user is signned in' do
      subject { get users_path }

      before do
        @user = create(:user, activated: true, activated_at: Time.zone.now)
      end

      it 'retunrs a 200 response' do
        sign_in_as(@user)
        subject
        expect(response).to have_http_status(200)
      end

      it 'render index template' do
        sign_in_as(@user)
        expect(subject).to render_template(:index)
      end
    end

    context 'when user is not signned in' do
      subject { get users_path }

      it 'retunrs a 302 response' do
        subject
        expect(response).to have_http_status(302)
      end

      it 'render index template' do
        expect(subject).to redirect_to(login_url)
      end
    end
  end

  describe "#edit" do
    context 'when user is signned in' do
      before do
        @user = create(:user, activated: true, activated_at: Time.zone.now)
      end

      subject { get edit_user_path(@user) }

      it 'retunrs a 200 response' do
        sign_in_as(@user)
        subject
        expect(response).to have_http_status(200)
      end

      it 'render edit template' do
        sign_in_as(@user)
        expect(subject).to render_template(:edit)
      end
    end

    context 'when user is not signned in' do
      before do
        @user = create(:user, activated: true, activated_at: Time.zone.now)
      end

      subject { get edit_user_path(@user) }

      it 'returns a 302 response' do
        subject
        expect(response).to have_http_status(302)
      end

      it 'render index template' do
        expect(subject).to redirect_to(login_url)
      end
    end
  end

  describe '#show' do
    
    before do
      @user = create(:user, activated: true, activated_at: Time.zone.now)
      @micropost = create(:micropost, user_id: @user.id, content: "test1")
    end

    subject { get users_path(@user) }
    it 'should get user success' do 
      sign_in_as(@user)
      subject
      expect(response).to have_http_status(200)
      expect(@user.microposts.reload.size).to eq(1)
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
    let(:invalid_user_params){
      {
        name: "test_name",
        password: "test123456"
      }
    }

    it 'should save user' do 
      post users_path, params: { user: user_params }
      expect(flash[:info]).to eq("Please check your email to activate your account.")
      expect(response).to have_http_status(302)
    end

    it 'should render new' do 
      post users_path, params: { user: invalid_user_params }
      expect(response).to render_template :new
    end
  end

  describe '#destroy' do
    let(:test_user) { create(:user, activated: true, activated_at: Time.zone.now) }
    let(:admin_user) { create(:user, activated: true, admin: true, activated_at: Time.zone.now) }

    subject { delete user_path(test_user)  }

    it 'should redirect to login ' do 
      subject
      expect(subject).to redirect_to login_path
    end

    it 'should redirect to root_path ' do 
      sign_in_as(test_user)
      subject
      expect(subject).to redirect_to root_path
    end

    it 'should return success' do 
      sign_in_as(admin_user)
      subject
      expect(flash[:success]).to eq("User deleted")
      expect(subject).to redirect_to users_url
    end
  end

  describe '#following' do
    let(:user) { create(:user, activated: true, activated_at: Time.zone.now) }
    let(:user_1) { create(:user, activated: true, activated_at: Time.zone.now) }
    let!(:relationship) { create(:relationship, follower_id: user.id, followed_id: user_1.id) }

    it 'should be successful' do 
      sign_in_as(user)
      get following_user_path(user)
      expect(assigns(:users).size).to  eq(1)
      expect(response).to  render_template "show_follow"
    end

  end
  
end
