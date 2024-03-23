class Api::V1::AuthController < Api::ApiController
  # GET /accounts
  def login
     user = authenticate_user(params[:email], params[:password])
 
     if user
       auth_token, refresh_token = generate_tokens(user)
       render json: { success: true, data: { auth_token: auth_token, refresh_token: refresh_token } }
     else
       render json: { success: false, errors: 'Invalid credentials' }, status: :unauthorized
     end
  end
 
  def refresh
     refresh_token = params[:refresh_token]
     user = find_user_by_refresh_token(refresh_token)
 
     if user
       new_auth_token = generate_auth_token(user)
       render json: { success: true, data: { auth_token: new_auth_token } }
     else
       render json: { success: false, errors: 'Invalid refresh token' }, status: :unauthorized
     end
  end

  def logout
    render status: 200
  end
 
  private

  def authenticate_user(email, password)
    user = User.find_by(email: email)
    return nil unless user.password == password
    user
 end
 
  def generate_tokens(user)
    auth_crypt = ::AUTH_TOKEN_KEY
    refresh_crypt = ::REFRESH_TOKEN_KEY
 
    auth_token = auth_crypt.encode({ sub: user.id, exp: Time.now.to_i + 3600 }, footer: 'auth_token')
    refresh_token = refresh_crypt.encode({ sub: user.id, exp: Time.now.to_i + 86400 }, footer: 'refresh_token')
 
    [auth_token, refresh_token]
  end
 
  def generate_auth_token(user)
    auth_crypt = ::AUTH_TOKEN_KEY
    auth_crypt.encode({ sub: user.id, exp: Time.now.to_i + 3600 }, footer: 'auth_token')
  end

  def find_user_by_refresh_token(token)
    decrypted = REFRESH_TOKEN_KEY.decode!(token)

    User.find(decrypted.claims["sub"])
  end
 end