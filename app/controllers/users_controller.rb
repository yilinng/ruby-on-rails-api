class UsersController < ApplicationController
    before_action :authorized, only: [:auto_login, :destroy, :index]

    # all user accounts lsit
    def index

     @user.role == 'basic'

      if @user.role == 'basic'
      return  render json: {message: 'you cannot see it'}
      end
      @user = User.all

      render json: { user: @user }
    end

  
    # REGISTER
    def create
      @findUser = User.find_by(email: params[:email])

      if @findUser
      return render json: {message: "user is signup, please try new one"}, status: :forbidden
      end

      @user = User.create(user_params)
      if @user.valid?
        exp = Time.now.to_i + 300*60
        token = encode_token({user_id: @user.id, exp: exp})

        @token = Token.new(token_params)
        @token.accesstoken = token
        @token.user_id = @user.id

        if @token.save

          session[:user_id] = @user.id
          session[:token] = token
          render json: {user: @user, token: token}
        else
          render json: @token.errors, status: :unprocessable_entity
        end
      else
        render json: {error: "Invalid username or password"}
      end
    end
  
    # LOGGING IN
    def login
      @user = User.find_by(email: params[:email])
  
      if @user && @user.authenticate(params[:password])
        #ruby is use second(ex: 1s-> 1)
        exp = Time.now.to_i + 300*60
        token = encode_token({user_id: @user.id, exp: exp})
        #The cookie (_session_id) has the HttpOnly flag set which means it can’t be accessed by JavaScript, 
        #thus it’s not vulnerable to XSS attacks. As well, the cookie value is encrypted

        @findToken = Token.find_by(user_id: @user.id)
        #checkexpired = Time.now.to_i >= @findToken.created_at.to_i + 1*60
        if @findToken  
        return render json: {message: "user is login"}, status: :forbidden
        end
        
        # token not found create new one
        @token = Token.new(token_params)
        @token.accesstoken = token
        @token.user_id = @user.id

        if @token.save
          session[:token] = token
          render json: {user: @user, token: token} 
        else
          render json: @token.errors, status: :unprocessable_entity
        end
       
      else
        render json: {error: "Invalid username or password"}
      end
    end
  
  
    def auto_login 
      render json: { user: @user, session: session[:token] }
    end
  
    # Logg Out
    def destroy
      Token.find_by(user_id: @user.id).destroy
      render json: { message: 'log out success!!' }
    end
  
    private
  
    def user_params
      params.permit(:username, :email, :password, :role)
    end

    def token_params
      params.permit(:accesstoken, :user_id)
    end

  end