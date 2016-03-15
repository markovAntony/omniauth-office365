require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Office365 < OmniAuth::Strategies::OAuth2
      option :name, :office365

      option :client_options, {
        site:          'https://outlook.office365.com/',
        token_url:     'https://login.windows.net/common/oauth2/v2.0/token',
        authorize_url: 'https://login.windows.net/common/oauth2/v2.0/authorize'
      }

      uid { raw_info["objectId"] }

      info do
        {
          'email' => raw_info["userPrincipalName"],
          'name' => [raw_info["givenName"], raw_info["surname"]].join(' '),
          'nickname' => raw_info["displayName"]
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get(authorize_params.resource + 'Me').parsed
      end
    end
  end
end
