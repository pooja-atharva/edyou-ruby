module CustomTokenResponse
  def body
    user_details = User.find(@token.resource_owner_id)
    if user_details.blocked
      {
        success: false,
        message: "You have been blocked by admin",
        data: {},
        meta: {},
        errors: []
      }
    else
      {
        success: true,
        message: I18n.t('devise.sessions.signed_in'),
        data: {
          user: ActiveModelSerializers::SerializableResource.new(user_details, serializer: Api::V1::UserSerializer),
          token: super['access_token']
        },
        meta: {},
        errors: []
      }
    end
  end
end
