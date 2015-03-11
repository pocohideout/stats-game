class Api::V1::SessionsController < Devise::SessionsController
  skip_before_filter :verify_signed_out_user
  respond_to :json
  
  # POST /users/sign_in
  # Reset the authentication token every time
  def create
    respond_to do |format|
      format.html { super }
      format.json do
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)
        current_user.update(authentication_token: nil)

        render json: { user: { token: current_user.authentication_token } }
      end
    end
  end

  # DELETE /users/sign_out
  def destroy
    respond_to do |format|
      format.html { super }
      format.json do
        token = request.headers['X-User-Token']
        email = request.headers['X-User-Email']
        
        if !token || !email
          render json: {}.to_json, status: :unauthorized
          return
        end
        
        user = User.where(email: email, authentication_token: token)
        if !user
          render json: {}.to_json, status: :unauthorized
        else
          user.update(authentication_token: nil)
          render json: {}.to_json, status: :ok
        end
      end
    end
  end

end