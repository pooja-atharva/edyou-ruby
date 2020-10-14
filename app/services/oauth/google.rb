module Oauth
    class Google
      include HTTParty
      DATA_URL = 'https://www.googleapis.com/oauth2/v3/userinfo'

      def initialize(token)
        @token = token
      end

      def build_user
        bearer = "Bearer " + @token
        response = HTTParty.get("#{DATA_URL}", :headers => { "Authorization" => bearer})
        profile = response.parsed_response
        {
          email: profile['email'],
          google_id: profile['sub'],
          name: profile['name']
        }
      end

    end
  end
