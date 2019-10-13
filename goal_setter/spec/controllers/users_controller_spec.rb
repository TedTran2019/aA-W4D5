require 'rails_helper'

RSpec.describe UsersController, type: :controller do
	describe 'GET #show' do
		context 'User with id exists' do
			it "redirects to the user's show page" do
				FactoryBot.create(:user)
				get :show, params: { id: User.last.id }
				expect(response).to render_template('show')
			end
		end

		context "User with id doesn't exist" do
			before(:each) { get :show, params: { id: -1} }
			it 'renders a not_found error page' do
				expect(response).to render_template('not_found')
			end

			it 'has a not_found http_status 404' do
				expect(response).to have_http_status(404)
			end
		end
	end

	describe 'GET #new' do
		it 'renders the new template' do
			get :new
			expect(response).to render_template('new')
		end
	end

	describe 'POST #create' do
		context 'invalid parameters' do
			it 'renders new page with errors' do
				post :create, params: { user: { username:'Ted', password: 'nope'}}
				expect(response).to render_template('new')
				expect(flash[:errors]).to_not eq(nil)
			end
		end

		context 'valid parameters' do
			before(:each) { post :create, params: { user: { username:'Ted', password: '123456'}}}
			it "redirects to the user's show page" do
				expect(response).to redirect_to(user_url(User.last))
			end

			it 'logs in the user' do
				expect(session[:session_token]).to eq(User.last.session_token)
			end
		end
	end
end
