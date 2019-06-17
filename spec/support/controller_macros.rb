# frozen_string_literal: true

module ControllerMacros
  extend ActiveSupport::Concern

  module ClassMethods
    def unauthorized(defination, rest_method, params = {})
      it 'should return status 401: unauthorized' do
        trigger_action(defination, rest_method, params)
        expect(response.status).to eq(302)
      end
    end

    def create_records
      before do
        @user = FactoryBot.create(:user)
      end
    end

    def login_verified_user
      before do
        request.env['devise.mapping'] = Devise.mappings[:user]
        @user = FactoryBot.create(:user)
        sign_in @user
      end
    end

  end
end

RSpec.configure do |config|
  config.include ControllerMacros, type: :controller
end
