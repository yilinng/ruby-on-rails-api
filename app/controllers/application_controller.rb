class ApplicationController < ActionController::API
    include ActionController::Cookies
    
      before_action :authorized
  
    def encode_token(payload)
      JWT.encode(payload, ENV['ACCESS_TOKEN'])
    end
  
    def auth_header
      # { Authorization: 'Bearer <token>' }
      request.headers['Authorization']
    end
  
    def decoded_token
      if auth_header
        token = auth_header.split(' ')[1]
        # header: { 'Authorization': 'Bearer <token>' }
        begin
          JWT.decode(token, ENV['ACCESS_TOKEN'], true, algorithm: 'HS256')
        rescue JWT::ExpiredSignature
          # Handle expired token, e.g. logout user or deny access
          nil
        end
      end
    end
  
    def logged_in_user

      if decoded_token
        user_id = decoded_token[0]['user_id']
        @token = Token.find_by(user_id: user_id)
        #token find 
        if @token
        @user = User.find_by(id: user_id)
        end
      end
    end
    
      #A method ending with ? should return a value which can be evaluated to true or false
      ##logged_in? coerces the return value of current_user into a Boolean by use of a double-bang
    def logged_in?
      !!logged_in_user 
    end
  
    def authorized
      render json: { message: 'Please log in' }, status: :unauthorized unless logged_in? 
    end
    
  end
  