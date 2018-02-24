module SessionsHelper
  def login(user)
    user.generate_api_key
  end

  def current_user
    api_key = get_evn_api_key
    @current_user ||= User.from_api_key(api_key, true)
  end

  def current_user?(user)
    user == current_user
  end

  def logged_in?
    !current_user.blank?
  end

  def logout
    if AppSettings[:authentication][:key_based]
      env_key = get_evn_api_key
      Rails.cache.delete User.cached_api_key(env_key) if User.from_api_key(env_key)
    else
      @current_user.update(activation_digest: nil)
    end
    @current_user = nil
  end

  def get_evn_api_key
    request.env['HTTP_X_API_KEY']
  end
end