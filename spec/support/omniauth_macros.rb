# frozen_string_literal: true

OmniAuth.config.test_mode = true

omniauth_hash = { provider: 'facebook',
                  uid: 12_345,
                  info: {
                    name: 'John Doe',
                    email: 'john@doe.com'
                  } }

OmniAuth.config.add_mock(:facebook, omniauth_hash)
