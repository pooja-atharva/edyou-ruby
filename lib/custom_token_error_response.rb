module CustomTokenErrorResponse
  def body
    {
      success: false,
      message: I18n.t('devise.failure.invalid', authentication_keys: User.authentication_keys.join('/')),
      data: {},
      meta: {},
      errors: []
    }
  end
end
