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

  descibe '#show' do

      context 'when user is signned in' do
        subject { get users_path }

        before do
          @user = create(:user, activated: true, activated_at: Time.zone.now)
          sign_in_as(@user)
          get :show, params: { id: @user.id }
        end

        it 'render show template' do
          expect(response).to be_successful
        end
  
  end

  descirbe '#create' do
    # TODO
  end

  describe '#destroy' do

  context 'when user is signned in' do
    subject { get users_path }

    before do
      @user = create(:user, activated: true, activated_at: Time.zone.now)
      sign_in_as(@user)
      get :destroy, params: { id: @user.id }
    end

    it 'delete the user' do
      expect(flash[:success]).to have_content('User deleted')
      expect(response).to redirect_to(users_url)
    end
 
  end

  describe '#following' do

  context 'when user is signned in' do
    subject { get users_path }

    before do
      @user = create(:user, activated: true, activated_at: Time.zone.now)
      sign_in_as(@user)
    end

  end
end
