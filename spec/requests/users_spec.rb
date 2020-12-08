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
      sign_in_as(@user)
    end

    subject { get user_path(@user) }

    it 'should get user success' do 
      subject
      expect(response).to have_http_status(200)
      expect(@user.microposts.reload.size).to eq(0)
    end
  end

  describe '#create' do
    # TODO
    context "success" do
      
      it 'should return success' do 
        post users_path, params: { user: {
          name: "test",
          password: "123123",
          email: "test@email.com"
        } }
        expect(response).to have_http_status(302)
      end
    end
    
    context "fail" do
      it 'should return fail' do 
        post users_path, params: { user: {
          name: "test",
          password: "123123"
        } }
        expect(subject).to render_template(:new)
      end
    end
  end
  

  describe '#destroy' do
    # TODO
    let(:user_delete) { create(:user, activated: true, activated_at: Time.zone.now) }

    subject { delete user_path(user_delete)  }

    it 'should return success' do 
      sign_in_as(user_delete)
      subject
      expect(flash[:success]).to eq("User deleted")
    end
  end

  describe '#following' do
    # TODO
    let(:user) { create(:user, activated: true, activated_at: Time.zone.now) }
    let(:user_following) { create(:user, activated: true, activated_at: Time.zone.now) }

    it 'should be successful' do 
      sign_in_as(user)
      get following_user_path(user)
      expect(response).to render_template "show_follow"
    end
  end
  
end