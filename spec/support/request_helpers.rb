# frozen_string_literal: true

module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  module AuthHelpers
    def auth_headers(user)
      authentication_token = user.authentication_tokens.create(auth_token: SecureRandom.hex(20))
      {
        'Authorization': "Token token=#{authentication_token.auth_token}"
      }
    end
  end
end
