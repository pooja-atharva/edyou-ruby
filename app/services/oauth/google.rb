module Oauth
    class Google
      include HTTParty
      DATA_URL = 'https://www.googleapis.com/oauth2/v3/userinfo'

      def initialize(params)
        @name  = params[:name]
        @email = params[:email]
        #@user_type = params[:user_type]
        #@token = params[:token]
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
      def custom_build_user
       {
          email: @email,
          user_type: "google",
          name: @name,
          password: Devise.friendly_token[0,20]
        }
      end

    end
  end
